import UIKit
import SpriteKit

public class EMAnimationViewController: UIViewController {
    
    public lazy var animationView: SKView = SKView()
    
    private func createScene(withReferenceView view: UIView) -> SKScene {
        let dimension: CGFloat = min(view.frame.width, view.frame.height)
        let size: CGSize = CGSize(width: dimension, height: dimension)
        
        let scene: SKScene = SKScene(size: size)
        scene.backgroundColor = .lightGray
        
        self.addEmoji(to: scene)
        self.animateNodes(scene.children)
        
        return scene
    }
    
    public override func loadView() {
        super.loadView()
        self.view.addSubview(self.animationView)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard self.animationView.scene == nil else {
            return
        }
        
        let scene = self.createScene(withReferenceView: self.view)
        self.animationView.frame.size = scene.size
        self.animationView.presentScene(scene)
        
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.animationView.center.x = self.view.bounds.midX
        self.animationView.center.y = self.view.bounds.midY
    }
    
    // MARK: - Animation
    
    public func addEmoji(to scene: SKScene) {
        let allEmoji: [Character] = ["🌯", "🌮", "🍔", "🍕"]
        let distance = floor(scene.size.width / 4)
        
        for (index, emoji) in allEmoji.enumerated() {
            let node = SKLabelNode()
            node.render(emoji: emoji)
            node.position.y = floor(scene.size.height / 2)
            node.position.x = distance * (CGFloat(index) + 0.5)
            scene.addChild(node)
        }
    }
    
    public func animateNodes(_ nodes: [SKNode]) {
        for (index, node) in nodes.enumerated() {
            node.run(.sequence([
                .wait(forDuration: TimeInterval(index) * 0.2),
                .repeatForever(.sequence([
                    // A group of actions get performed simultaneously
                    .group([
                        .sequence([
                            .scale(to: 1.5, duration: 0.3),
                            .scale(to: 1, duration: 0.3)
                            ]),
                        // Rotate by 360 degrees (pi * 2 in radians)
                        .rotate(byAngle: .pi * 2, duration: 0.6)
                        ]),
                    .wait(forDuration: 2)
                    ]))
                ]))
        }
    }

}

public extension SKLabelNode {
    public func render(emoji: Character) {
        self.fontSize = 51
        self.text = String(emoji)
        
        self.verticalAlignmentMode = .center
        self.horizontalAlignmentMode = .center
    }
}
