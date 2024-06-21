//
//  ViewController.swift
//  TeamBrazil
//
//  Created by Ezequiel dos Santos on 20/06/2024.
//

import Cocoa
import SpriteKit
import GameplayKit

class ViewController: NSViewController {
    
    var sceneNode: LabyrinthScene?
    @IBOutlet var skView: SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let scene = GKScene(fileNamed: "LabyrinthScene") {
//            if let sceneNode = scene.rootNode as! LabyrinthScene? {
////                self.sceneNode = sceneNode
////                sceneNode.entities = scene.entities
////                sceneNode.graphs = scene.graphs
////                sceneNode.scaleMode = .aspectFill
////                
//                if let view = self.skView {
//                    view.presentScene(sceneNode)
//                    view.ignoresSiblingOrder = true
//                    view.showsFPS = true
//                    view.showsNodeCount = true
//                }
//            }
//        }
        
        if let view = self.view as! SKView? {
              // Load the SKScene from 'GameScene.sks'
              let scene = MazeScene(size: CGSize(width: 800, height: 600))
              scene.scaleMode = .aspectFill
              
              // Present the scene
              view.presentScene(scene)
              
              view.ignoresSiblingOrder = true
              
              view.showsFPS = true
              view.showsNodeCount = true
          }
        
        // Set up a subscription to the response property of the appModel
        
        
    }
}

