//
//  MazeScene.swift
//  TeamBrazil
//
//  Created by Ezequiel dos Santos on 21/06/2024.
//

import Foundation
import SpriteKit
import GameplayKit

class MazeScene: SKScene {
    
    let tileSize = 32
    let mapWidth = 25
    let mapHeight = 25
    var map = [[Int]]()
    var character: SKSpriteNode!
    var solutionPath: [GKGridGraphNode] = []
    
    override func didMove(to view: SKView) {
        generateMaze()
        drawMap()
        addCharacter()
        showSolution()
        
        // Enable keyboard input
        view.window?.becomeFirstResponder()
    }
    
    func generateMaze() {
        // Initialize the map with walls
        map = Array(repeating: Array(repeating: 1, count: mapWidth), count: mapHeight)
        
        var walls = [(x: Int, y: Int)]()
        let startX = Int.random(in: 0..<mapWidth)
        let startY = Int.random(in: 0..<mapHeight)
        
        map[startY][startX] = 0
        walls += getWalls(x: startX, y: startY)
        
        while !walls.isEmpty {
            let randomIndex = Int.random(in: 0..<walls.count)
            let (x, y) = walls.remove(at: randomIndex)
            
            if canBeCarved(x: x, y: y) {
                map[y][x] = 0
                walls += getWalls(x: x, y: y)
            }
        }
    }
    
    func getWalls(x: Int, y: Int) -> [(Int, Int)] {
        var walls = [(Int, Int)]()
        if x > 1 { walls.append((x - 1, y)) }
        if x < mapWidth - 2 { walls.append((x + 1, y)) }
        if y > 1 { walls.append((x, y - 1)) }
        if y < mapHeight - 2 { walls.append((x, y + 1)) }
        return walls
    }
    
    func canBeCarved(x: Int, y: Int) -> Bool {
        var adjacentFloors = 0
        if x > 0 && map[y][x - 1] == 0 { adjacentFloors += 1 }
        if x < mapWidth - 1 && map[y][x + 1] == 0 { adjacentFloors += 1 }
        if y > 0 && map[y - 1][x] == 0 { adjacentFloors += 1 }
        if y < mapHeight - 1 && map[y + 1][x] == 0 { adjacentFloors += 1 }
        return adjacentFloors == 1
    }
    
    func drawMap() {
        for y in 0..<mapHeight {
            for x in 0..<mapWidth {
                let tile = SKSpriteNode(color: map[y][x] == 1 ? .brown : .gray, size: CGSize(width: tileSize, height: tileSize))
                tile.position = CGPoint(x: x * tileSize + tileSize / 2, y: y * tileSize + tileSize / 2)
                tile.name = "tile_\(x)_\(y)"
                addChild(tile)
            }
        }
    }
    
    func addCharacter() {
        character = SKSpriteNode(color: .blue, size: CGSize(width: tileSize, height: tileSize))
        
        // Find a valid start position
        var startX = 0
        var startY = 0
        repeat {
            startX = Int.random(in: 0..<mapWidth)
            startY = Int.random(in: 0..<mapHeight)
        } while map[startY][startX] != 0
        
        character.position = CGPoint(x: startX * tileSize + tileSize / 2, y: startY * tileSize + tileSize / 2)
        addChild(character)
    }
    
    func showSolution() {
        let graph = GKGridGraph(fromGridStartingAt: vector_int2(0, 0), width: Int32(mapWidth), height: Int32(mapHeight), diagonalsAllowed: false) 
        
//        { (node) -> Bool in
//            let position = node.gridPosition
//            return self.map[Int(position.y)][Int(position.x)] == 0
//        }
        
        // Start and end nodes
        let startNode = graph.node(atGridPosition: vector_int2(Int32(character.position.x) / Int32(tileSize), Int32(character.position.y) / Int32(tileSize)))
        let endNode = graph.node(atGridPosition: vector_int2(Int32(mapWidth - 1), Int32(mapHeight - 1)))
        
        // Find path using GameplayKit
        if let path = graph.findPath(from: startNode!, to: endNode!) as? [GKGridGraphNode] {
            solutionPath = path
            drawSolutionPath(path)
        }
    }
    
    func drawSolutionPath(_ path: [GKGridGraphNode]) {
        for node in path {
            let solutionTile = SKSpriteNode(color: .green, size: CGSize(width: tileSize, height: tileSize))
            solutionTile.position = CGPoint(x: Int(node.gridPosition.x) * tileSize + tileSize / 2, y: Int(node.gridPosition.y) * tileSize + tileSize / 2)
            addChild(solutionTile)
        }
    }
    
    override func keyDown(with event: NSEvent) {
        let key = event.keyCode
        
        // Define movement actions based on key codes
        switch key {
        case 0x00: // A key
            moveCharacter(dx: -1, dy: 0)
        case 0x01: // S key
            moveCharacter(dx: 0, dy: -1)
        case 0x0D: // W key
            moveCharacter(dx: 0, dy: 1)
        case 0x02: // D key
            moveCharacter(dx: 1, dy: 0)
        default:
            break
        }
    }
    
    func moveCharacter(dx: Int, dy: Int) {
        let newX = Int(character.position.x) / tileSize + dx
        let newY = Int(character.position.y) / tileSize + dy
        
        // Ensure the new position is within the map and is a floor
        if newX >= 0 && newX < mapWidth && newY >= 0 && newY < mapHeight && map[newY][newX] == 0 {
            character.position = CGPoint(x: newX * tileSize + tileSize / 2, y: newY * tileSize + tileSize / 2)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
