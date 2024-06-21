//
//  RankingScene.swift
//  KeepCalm
//
//  Created by Ezequiel dos Santos on 21/06/2024.
//

import Foundation
import SpriteKit

class RankingScene: SKScene {
    private var initialsTextField: UITextField?
    private var saveButton: SKLabelNode!
    private var restartButton: SKLabelNode!
    private var rankings: [RankingValue] = []

    override func didMove(to view: SKView) {
        backgroundColor = .orange
        setupInitialsTextField()
        setupSaveButton()
        setupRestartButton()
        loadRankings()
        displayRankings()
    }

    private func setupInitialsTextField() {
        initialsTextField = UITextField(frame: CGRect(x: size.width / 4, y: size.height / 2, width: size.width / 2, height: 40))
        initialsTextField?.borderStyle = .roundedRect
        initialsTextField?.placeholder = "Enter your initials"
        initialsTextField?.backgroundColor = .black
        initialsTextField?.autocorrectionType = .no
        initialsTextField?.keyboardType = .default
        initialsTextField?.returnKeyType = .done
        initialsTextField?.clearButtonMode = .whileEditing
        initialsTextField?.contentVerticalAlignment = .center
        initialsTextField?.delegate = self
        initialsTextField?.textColor = .white
        view?.addSubview(initialsTextField!)
    }

    private func setupSaveButton() {
        saveButton = SKLabelNode(fontNamed: "Chalkduster")
        saveButton.text = "Save Score"
        saveButton.fontSize = 30
        saveButton.fontColor = .black
        saveButton.position = CGPoint(x: size.width / 2, y: size.height / 3)
        saveButton.name = "saveButton"
        addChild(saveButton)
    }

    private func setupRestartButton() {
        restartButton = SKLabelNode(fontNamed: "Chalkduster")
        restartButton.text = "Restart Game"
        restartButton.fontSize = 30
        restartButton.fontColor = .black
        restartButton.position = CGPoint(x: size.width / 2, y: size.height / 4)
        restartButton.name = "restartButton"
        addChild(restartButton)
    }

    private func loadRankings() {
        // Load rankings from UserDefaults or another storage solution
        let defaults = UserDefaults.standard
        if let savedRankings = defaults.object(forKey: "rankings") as? Data {
            let decoder = JSONDecoder()
            if let loadedRankings = try? decoder.decode([RankingValue].self, from: savedRankings) {
                rankings = loadedRankings
            }
        }
    }

    private func saveRankings() {
        let defaults = UserDefaults.standard
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(rankings) {
            defaults.set(encoded, forKey: "rankings")
        }
    }

    private func displayRankings() {
        for (index, ranking) in rankings.enumerated() {
            let rankLabel = SKLabelNode(fontNamed: "Chalkduster")
            rankLabel.text = "\(index + 1). \(ranking.name): \(ranking.points)"
            rankLabel.fontSize = 20
            rankLabel.fontColor = .black
            rankLabel.position = CGPoint(x: size.width / 2, y: size.height - CGFloat(50 + (index * 30)))
            addChild(rankLabel)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodes = nodes(at: location)

        for node in nodes {
            if node.name == "saveButton" {
                saveInitialsAndScore()
            } else if node.name == "restartButton" {
                restartGame()
            }
        }
    }

    private func saveInitialsAndScore() {
        guard let initials = initialsTextField?.text, !initials.isEmpty else { return }
        let score = UserDefaults.standard.integer(forKey: "lastScore")
        rankings.append(RankingValue(name: initials, points: score))
        rankings.sort { $0.points > $1.points }
        saveRankings()
        initialsTextField?.removeFromSuperview()
        displayRankings()
    }

    private func restartGame() {
        initialsTextField?.removeFromSuperview() // Remove the text field before transitioning
        let gameScene = GameScene(size: size)
        gameScene.scaleMode = scaleMode
        let transition = SKTransition.flipHorizontal(withDuration: 0.5)
        view?.presentScene(gameScene, transition: transition)
    }
}

extension RankingScene: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

struct RankingValue: Codable {
    var name: String
    var points: Int
}

