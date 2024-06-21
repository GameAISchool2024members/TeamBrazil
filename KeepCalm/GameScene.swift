import Foundation
import SpriteKit
import AVFoundation

enum CoinType {
    case regular
    case red
    case blue
    case purple
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    private var player: SKSpriteNode!
    private var isJumping = false
    private var background1: SKSpriteNode!
    private var background2: SKSpriteNode!
    private var coinCount = 0
    private var jumpCount = 30 // Start with 30 jumps
    private var redCoinCount = 0
    private var coinLabel: SKLabelNode!
    private var jumpLabel: SKLabelNode!
    private var gameOverLabel: SKLabelNode!
    private var backgroundMusicPlayer: AVAudioPlayer?
    private var originalSpeed: CGFloat = 1.0
    
    // Sound effects
    private var regularCoinSound: SKAction!
    private var redCoinSound: SKAction!
    private var blueCoinSound: SKAction!
    private var purpleCoinSound: SKAction!

    override func didMove(to view: SKView) {
        backgroundColor = .red
        loadSounds()
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        setupLabels()
        setupBackground()
        setupPlayer()
        setupPhysics()
        startSpawningCoins()
        playBackgroundMusic()
    }
    
    private func loadSounds() {
        regularCoinSound = SKAction.playSoundFileNamed("regularCoinSound.wav", waitForCompletion: false)
        redCoinSound = SKAction.playSoundFileNamed("redCoinSound.wav", waitForCompletion: false)
        blueCoinSound = SKAction.playSoundFileNamed("blueCoinSound.wav", waitForCompletion: false)
        purpleCoinSound = SKAction.playSoundFileNamed("purpleCoinSound.wav", waitForCompletion: false)
    }

    private func setupBackground() {
        if background1 != nil {
            background1.removeFromParent()
        }
        if background2 != nil {
            background2.removeFromParent()
        }

        let texture = SKTexture(imageNamed: "backgroundImage")
        background1 = SKSpriteNode(texture: texture)
        background1.size = calculateAspectFillSize(for: texture)
        background1.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background1.zPosition = -1
        addChild(background1)

        background2 = SKSpriteNode(texture: texture)
        background2.size = calculateAspectFillSize(for: texture)
        background2.position = CGPoint(x: size.width + size.width / 2, y: size.height / 2)
        background2.zPosition = -1
        addChild(background2)
    }

    private func calculateAspectFillSize(for texture: SKTexture) -> CGSize {
        let textureSize = texture.size()
        let aspectRatio = textureSize.width / textureSize.height
        let height = size.height
        let width = height * aspectRatio

        return CGSize(width: width, height: height)
    }

    override func update(_ currentTime: TimeInterval) {
        background1.position.x -= 2
        background2.position.x -= 2

        if background1.position.x <= -background1.size.width / 2 {
            background1.position.x = background2.position.x + background2.size.width
        }
        if background2.position.x <= -background2.size.width / 2 {
            background2.position.x = background1.position.x + background1.size.width
        }
    }

    private func setupPlayer() {
        if player != nil {
            player.removeFromParent()
        }
        player = SKSpriteNode(imageNamed: "hue")
        player.size = CGSize(width: 120, height: 120)
        player.position = CGPoint(x: size.width / 4, y: size.height / 3)
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.categoryBitMask = 1
        player.physicsBody?.contactTestBitMask = 2
        player.physicsBody?.collisionBitMask = 0
        player.physicsBody?.affectedByGravity = false
        addChild(player)
    }

    private func setupPhysics() {
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
    }

    private func setupLabels() {
        if coinLabel == nil {
            coinLabel = SKLabelNode(fontNamed: "Chalkduster")
            coinLabel.fontSize = 30
            coinLabel.fontColor = .black
            coinLabel.horizontalAlignmentMode = .left
            coinLabel.zPosition = 1
            addChild(coinLabel)
        }
        
        if jumpLabel == nil {
            jumpLabel = SKLabelNode(fontNamed: "Chalkduster")
            jumpLabel.fontSize = 30
            jumpLabel.fontColor = .black
            jumpLabel.horizontalAlignmentMode = .left
            jumpLabel.zPosition = 1
            addChild(jumpLabel)
        }
        
        coinLabel.position = CGPoint(x: 10, y: size.height - 40)
        coinLabel.text = "Coins: \(coinCount)"

        jumpLabel.position = CGPoint(x: 10, y: size.height - 80)
        jumpLabel.text = "Jumps: \(jumpCount)" // Start with 30 jumps
    }

    private func startSpawningCoins() {
        let spawn = SKAction.run { [weak self] in self?.spawnCoin() }
        let delay = SKAction.wait(forDuration: 3.0) // More spaced
        let spawnSequence = SKAction.sequence([spawn, delay])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        run(spawnForever)
    }

    private func spawnCoin() {
        let coinType = getRandomCoinType()
        let coinImageName: String

        switch coinType {
        case .regular:
            coinImageName = "banana"
        case .red:
            coinImageName = "poo"
        case .blue:
            coinImageName = "blueberries"
        case .purple:
            coinImageName = "cherries"
        }
        let coinSize = CGSize(width: 60, height: 60) // Adjust the size here

        let coin = SKSpriteNode(imageNamed: coinImageName)
        coin.name = coinImageName
        coin.size = coinSize
        let maxYPosition = abs(size.height - coin.size.height)
        let minYPosition = player.position.y + 50
        let yPosition = CGFloat.random(in: minYPosition...maxYPosition)
        coin.position = CGPoint(x: size.width + coin.size.width / 2, y: yPosition)
        coin.physicsBody = SKPhysicsBody(rectangleOf: coin.size)
        coin.physicsBody?.categoryBitMask = 2
        coin.physicsBody?.contactTestBitMask = 1
        coin.physicsBody?.collisionBitMask = 0
        coin.physicsBody?.affectedByGravity = false
        addChild(coin)

        let moveLeft = SKAction.moveBy(x: -size.width - coin.size.width, y: 0, duration: 4.0)
        let remove = SKAction.removeFromParent()
        let moveSequence = SKAction.sequence([moveLeft, remove])
        coin.run(moveSequence)
    }

    private func getRandomCoinType() -> CoinType {
        let randomValue = Int.random(in: 1...100)
        switch randomValue {
        case 1...80:
            return .regular
        case 81...90:
            return .blue
        case 91...97:
            return .purple
        default:
            return .red
        }
    }

    func updateMotionData(_ motionData: MotionData) {
        guard let player = player else { return }

        let jumpThreshold: CGFloat = 0.5

        if motionData.y > jumpThreshold && !isJumping {
            isJumping = true
            jumpCount -= 1 // Decrease jumps
            updateLabels()
            if jumpCount <= 0 {
                gameOver()
                return
            }

            let jumpHeight: CGFloat = 300.0
            let jumpDuration: TimeInterval = 0.4

            let jumpUpAction = SKAction.moveBy(x: 0, y: jumpHeight, duration: jumpDuration / 2)
            let jumpDownAction = SKAction.moveBy(x: 0, y: -jumpHeight, duration: jumpDuration / 2)
            let jumpSequence = SKAction.sequence([jumpUpAction, jumpDownAction])

            player.run(jumpSequence) { [weak self] in
                self?.isJumping = false
            }
        }
    }

    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == 1 || contact.bodyB.categoryBitMask == 1 {
            if contact.bodyA.categoryBitMask == 2 {
                handleCoinCollection(contact.bodyA.node as! SKSpriteNode)
            } else if contact.bodyB.categoryBitMask == 2 {
                handleCoinCollection(contact.bodyB.node as! SKSpriteNode)
            }
        }
    }

    private func handleCoinCollection(_ coin: SKSpriteNode) {
        if let coinName = coin.name {
            switch coinName {
            case "banana":
                coinCount += 1
                run(regularCoinSound)
            case "poo":
                coinCount -= 10
                jumpCount -= 5
                run(redCoinSound)
            case "blueberries":
                jumpCount += 1
                run(blueCoinSound)
            case "cherries":
                adjustGameSpeed(to: 1.5, duration: 10) // No effect on game speed
                run(purpleCoinSound)
            default:
                break
            }
        }
        updateLabels()
        coin.removeFromParent()
    }

    private func adjustGameSpeed(to newSpeed: CGFloat, duration: TimeInterval) {
        let currentSpeed = self.speed
        let adjustSpeed = SKAction.run { [weak self] in
            self?.speed = newSpeed
        }
        let wait = SKAction.wait(forDuration: duration)
        let revertSpeed = SKAction.run { [weak self] in
            self?.speed = currentSpeed
        }
        let sequence = SKAction.sequence([adjustSpeed, wait, revertSpeed])
        run(sequence)
    }

    private func updateLabels() {
        coinLabel.text = "Coins: \(coinCount)"
        jumpLabel.text = "Jumps: \(jumpCount)"
    }

//    private func gameOver() {
//        print("Game Over!")
//        showGameOverMessage()
//        player.removeFromParent()
//    }

//    private func showGameOverMessage() {
//        gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
//        gameOverLabel.fontSize = 40
//        gameOverLabel.fontColor = .red
//        gameOverLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
//        gameOverLabel.text = "Game Over!"
//        gameOverLabel.alpha = 0.0
//        gameOverLabel.zPosition = 1
//        addChild(gameOverLabel)
//
//        let fadeIn = SKAction.fadeIn(withDuration: 0.5)
//        let wait = SKAction.wait(forDuration: 2.0)
//        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
//        let remove = SKAction.removeFromParent()
//        let sequence = SKAction.sequence([fadeIn, wait, fadeOut, remove])
//        gameOverLabel.run(sequence)
//    }

    private func playBackgroundMusic() {
        if let musicURL = Bundle.main.url(forResource: "samba", withExtension: "mp3") {
            do {
                backgroundMusicPlayer = try AVAudioPlayer(contentsOf: musicURL)
                backgroundMusicPlayer?.numberOfLoops = -1
                backgroundMusicPlayer?.play()
            } catch {
                print("Error loading background music: \(error)")
            }
        }
    }
    
    private func gameOver() {
        print("Game Over!")
        UserDefaults.standard.set(coinCount, forKey: "lastScore")
        showGameOverMessage()
        backgroundMusicPlayer?.stop()
        player.removeFromParent()
    }

    private func showGameOverMessage() {
        gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
        gameOverLabel.fontSize = 40
        gameOverLabel.fontColor = .red
        gameOverLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
        gameOverLabel.text = "Game Over!"
        gameOverLabel.alpha = 0.0
        gameOverLabel.zPosition = 1
        addChild(gameOverLabel)

        let fadeIn = SKAction.fadeIn(withDuration: 0.5)
        let wait = SKAction.wait(forDuration: 2.0)
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        let remove = SKAction.removeFromParent()
        let transition = SKAction.run { [weak self] in
            let rankingScene = RankingScene(size: self?.size ?? CGSize(width: 1024, height: 768))
            rankingScene.scaleMode = self?.scaleMode ?? .aspectFill
            self?.view?.presentScene(rankingScene, transition: SKTransition.flipHorizontal(withDuration: 0.5))
        }
        let sequence = SKAction.sequence([fadeIn, wait, fadeOut, remove, transition])
        gameOverLabel.run(sequence)
    }
}

extension SKSpriteNode {
    func aspectFill() {
        guard let texture = self.texture else { return }
        let textureSize = texture.size()
        let aspectWidth = self.size.height / textureSize.height * textureSize.width
        let aspectHeight = self.size.width / textureSize.width * textureSize.height

        if aspectWidth >= self.size.width {
            self.size = CGSize(width: aspectWidth, height: self.size.height)
        } else {
            self.size = CGSize(width: self.size.width, height: aspectHeight)
        }
    }
}


