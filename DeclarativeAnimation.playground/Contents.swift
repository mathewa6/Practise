import SpriteKit
import PlaygroundSupport
import UIKit

/// Adapted from https://www.swiftbysundell.com/posts/building-a-declarative-animation-framework-in-swift-part-1

let frame: CGRect = CGRect(x: 0.0,
                           y: 0.0,
                           width: 500.0,
                           height: 500.0)
let view: UIView = UIView(frame: frame)

view.backgroundColor = .white

PlaygroundPage.current.liveView = view

public struct Animation {
    public let duration: TimeInterval
    public let closure: (UIView) -> Void
}

public extension Animation {
    public static func fadeIn(duration: TimeInterval = 0.3) -> Animation {
        return Animation(duration: duration,
                         closure: { $0.alpha = 1 })
    }
    
    public static func resize(to size: CGSize, duration: TimeInterval = 0.3) -> Animation {
        return Animation(duration: duration,
                         closure: { $0.bounds.size = size } )
    }
}

public extension UIView {
    public func animate(animations: [Animation]) {
        guard !animations.isEmpty else {
            return
        }
        
        var newAnimations: [Animation] = animations
        let animation: Animation = newAnimations.removeFirst()
        
        UIView.animate(withDuration: animation.duration,
                       animations: { animation.closure(self) },
                       completion: { _ in
                        self.animate(animations: newAnimations)
        })
    }
    
    func animate(inParallel animations: [Animation]) {
        for animation in animations {
            UIView.animate(withDuration: animation.duration) {
                animation.closure(self)
            }
        }
    }
}

let debugFrame: CGRect = CGRect(x: 125.0,
                                y: 125.0,
                                width: 60.0,
                                height: 60.0)
let debugView: UIView = UIView(frame: debugFrame)
debugView.backgroundColor = .red
debugView.layer.cornerRadius = debugFrame.width/2
debugView.alpha = 0.0

view.addSubview(debugView)

debugView.animate(inParallel: [
    .fadeIn(duration: 2.5),
    .resize(to: CGSize(width: 250.0, height: 250.0),
            duration: 2.5)
    ])