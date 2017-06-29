import SpriteKit
import PlaygroundSupport
import UIKit

class EMAnimationViewController: UIViewController {
    private func createScene(withReferenceView view: UIView) -> SKScene {
        let dimension: CGFloat = min(view.frame.width, view.frame.height)
        let size: CGSize = CGSize(width: dimension, height: dimension)
        
        let scene: SKScene = SKScene(size: size)
        scene.backgroundColor = .lightGray
        
        return scene
    }
}

PlaygroundPage.current.liveView = EMAnimationViewController()
