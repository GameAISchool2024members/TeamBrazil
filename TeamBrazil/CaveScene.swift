//
//  CaveScene.swift
//  TeamBrazil
//
//  Created by Ezequiel dos Santos on 20/06/2024.
//

import Foundation
import SpriteKit
import GameplayKit

class CaveScene: SKScene {
    
    let tileSize = 32
    let mapWidth = 25
    let mapHeight = 25
    var map = [[Int]]()
    var character: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        generateCave()
        drawMap()
        addCharacter()
        
        // Enable keyboard input
        view.window?.becomeFirstResponder()
    }
    
    func generateCave() {
        // Initialize the map with walls
        map = Array(repeating: Array(repeating: 1, count: mapWidth), count: mapHeight)
        
        // Starting point in the center of the map
        var x = mapWidth / 2
        var y = mapHeight / 2
        
        // Number of steps to walk
        let steps = mapWidth * mapHeight
        
        for _ in 0..<steps {
            map[y][x] = 0  // Make the current position a floor
            
            // Randomly choose a direction
            let direction = Int.random(in: 0..<4)
            switch direction {
            case 0: if x > 1 { x -= 1 }  // Left
            case 1: if x < mapWidth - 2 { x += 1 }  // Right
            case 2: if y > 1 { y -= 1 }  // Down
            case 3: if y < mapHeight - 2 { y += 1 }  // Up
            default: break
            }
        }
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
        character.position = CGPoint(x: (mapWidth / 2) * tileSize + tileSize / 2, y: (mapHeight / 2) * tileSize + tileSize / 2)
        addChild(character)
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
