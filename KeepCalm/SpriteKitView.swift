import Foundation
import SwiftUI
import SpriteKit

import SwiftUI
import SpriteKit

struct SpriteKitView: UIViewRepresentable {
    @Binding var gameScene: GameScene?

    class Coordinator: NSObject {
        var parent: SpriteKitView

        init(parent: SpriteKitView) {
            self.parent = parent
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> SKView {
        let view = SKView()
        let scene = GameScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        scene.scaleMode = .resizeFill
        view.presentScene(scene)
        DispatchQueue.main.async {
            self.gameScene = scene
        }
        return view
    }

    func updateUIView(_ uiView: SKView, context: Context) {
        // No-op
    }
}



