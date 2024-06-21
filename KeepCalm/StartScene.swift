import Foundation
import SpriteKit

class StartScene: SKScene {
    
    private var background1: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        backgroundColor = .white
        setupStartButton()
        let texture = SKTexture(imageNamed: "backgroundImage")
        background1 = SKSpriteNode(texture: texture)
        background1.size = calculateAspectFillSize(for: texture)
        background1.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background1.zPosition = -1
        addChild(background1)
    }
    
    private func setupStartButton() {
        let startButton = SKLabelNode(fontNamed: "Chalkduster")
        startButton.text = "Start Game"
        startButton.fontSize = 40
        startButton.fontColor = .black
        startButton.position = CGPoint(x: size.width / 2, y: size.height / 2)
        startButton.name = "startButton"
        addChild(startButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodes = nodes(at: location)
        
        for node in nodes {
            if node.name == "startButton" {
                let gameScene = GameScene(size: size)
                gameScene.scaleMode = scaleMode
                let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                view?.presentScene(gameScene, transition: transition)
            }
        }
    }
    
    private func calculateAspectFillSize(for texture: SKTexture) -> CGSize {
        let textureSize = texture.size()
        let aspectRatio = textureSize.width / textureSize.height
        let height = size.height
        let width = height * aspectRatio

        return CGSize(width: width, height: height)
    }
}
