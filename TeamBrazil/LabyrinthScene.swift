//
//  LabyrinthScene.swift
//  TeamBrazil
//
//  Created by Ezequiel dos Santos on 20/06/2024.
//

import Foundation
import SpriteKit
import GameplayKit

class LabyrinthScene: SKScene {
    
    var appModel = DataInterface()
    let tileSize: CGFloat = 40.0
    
    override func keyDown(with event: NSEvent) {
        if appModel.response.isEmpty == false {
            renderLabyrinth(response: appModel.response)
        }
        generateLabyrinth(prompt: "Generate a 10x10 labyrinth with a clear path from S (start) to E (end):")
    }
    
    override func didMove(to view: SKView) {
        generateLabyrinth(prompt: "Generate a 10x10 labyrinth with a clear path from S (start) to E (end):")
    }
    
    func generateLabyrinth(prompt: String) {
        appModel.prompt = prompt
        appModel.sendPrompt()
        
        appModel.completionBlock = { string in
            if self.appModel.isSending == false {
                self.renderLabyrinth(response: string)
            } else {
                self.generateLabyrinth(prompt: string)
            }
        }
//        appModel.$response.sink { [weak self] response in
//            
//        }.store(in: &cancellables)
    }
    
    func renderLabyrinth(response: String) {
        // Clear previous labyrinth
        self.removeAllChildren()
        
        // Split response into lines
        let lines = response.split(separator: "\n")
        
        for (rowIndex, line) in lines.enumerated() {
            for (colIndex, char) in line.enumerated() {
                let tileNode = SKShapeNode(rectOf: CGSize(width: tileSize, height: tileSize))
                tileNode.position = CGPoint(x: CGFloat(colIndex) * tileSize, y: CGFloat(-rowIndex) * tileSize)
                
                switch char {
                case "S":
                    tileNode.fillColor = .green
                case "E":
                    tileNode.fillColor = .red
                case "#":
                    tileNode.fillColor = .black
                case ".":
                    tileNode.fillColor = .white
                default:
                    continue
                }
                
                self.addChild(tileNode)
            }
        }
        
        // Validate the labyrinth
        if validateLabyrinth() {
            print("Labyrinth is valid.")
        } else {
            print("Labyrinth is invalid.")
        }
    }
    
    func validateLabyrinth() -> Bool {
        // Create a 2D array representation of the labyrinth
        var labyrinth = [[Int]]()
        self.children.forEach { node in
            if let shapeNode = node as? SKShapeNode {
                switch shapeNode.fillColor {
                case .green:
                    labyrinth.append([1]) // Start
                case .red:
                    labyrinth.append([2]) // End
                case .black:
                    labyrinth.append([0]) // Wall
                case .white:
                    labyrinth.append([1]) // Path
                default:
                    break
                }
            }
        }
        
        // Use GameplayKit to validate the labyrinth
        // Convert the labyrinth array into a GKGridGraph
        let graph = GKGridGraph(fromGridStartingAt: vector_int2(0, 0), width: Int32(labyrinth.count), height: Int32(labyrinth[0].count), diagonalsAllowed: false)
        
        for row in 0..<labyrinth.count {
            for col in 0..<labyrinth[row].count {
                if labyrinth[row][col] == 0 {
                    let node = graph.node(atGridPosition: vector_int2(Int32(col), Int32(row)))
                    graph.remove([node!])
                }
            }
        }
        
        let startNode = graph.node(atGridPosition: vector_int2(0, 0)) // Adjust based on start position
        if let endNode = graph.node(atGridPosition: vector_int2(Int32(labyrinth[0].count), Int32(labyrinth.count))) { // Adjust based on end  position
        
        let path = graph.findPath(from: startNode!, to: endNode)
        return !path.isEmpty
        }
        
        return true
    }
}
