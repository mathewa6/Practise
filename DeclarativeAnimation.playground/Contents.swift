import SpriteKit
import PlaygroundSupport
import UIKit

/// Adapted from https://www.swiftbysundell.com/posts/building-a-declarative-animation-framework-in-swift-part-1
/// and https://www.swiftbysundell.com/posts/building-a-declarative-animation-framework-in-swift-part-2

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

internal enum AnimationMode {
    case sequence
    case parallel
}

public final class AnimationToken {
    private let view: UIView
    private let animations: [Animation]
    private let mode: AnimationMode
    
    private var isValid: Bool = true
    
    internal init(view: UIView,
                  animations: [Animation],
                  mode: AnimationMode) {
        self.view = view
        self.animations = animations
        self.mode = mode
    }
    
    deinit {
        perform {}
    }
    
    internal func perform(completionHandler: @escaping () -> Void) {
        guard isValid else {
            return
        }
        
        isValid = false
        
        switch mode {
        case .sequence:
            view.performAnimations(animations, completionHandler: completionHandler)
        case .parallel:
            view.performAnimationsInParallel(animations,
                                             completionHandler: completionHandler)
        }
    }
}

public extension UIView {
    @discardableResult func animate(_ animations: [Animation]) -> AnimationToken {
        return AnimationToken(view: self,
                              animations: animations,
                              mode: .sequence)
    }
    
    @discardableResult func animate(inParallel animations: [Animation]) -> AnimationToken {
        return AnimationToken(view: self,
                              animations: animations,
                              mode: .parallel)
    }
}

internal extension UIView {
    func performAnimations(_ animations: [Animation], completionHandler: @escaping () -> Void) {
        
        guard !animations.isEmpty else {
            return completionHandler()
        }
        
        var animations = animations
        let animation = animations.removeFirst()
        
        UIView.animate(withDuration: animation.duration,
                       animations: { animation.closure(self) }) { _ in
                        self.performAnimations(animations,
                                               completionHandler: completionHandler)
        }
    }
    
    func performAnimationsInParallel(_ animations: [Animation], completionHandler: @escaping () -> Void) {
        
        guard !animations.isEmpty else {
            return completionHandler()
        }
        
        let animationCount = animations.count
        var completionCount = 0
        
        let animationHandler: () -> Void = {
            completionCount += 1
            
            if completionCount == animationCount {
                completionHandler()
            }
        }
        
        for animation in animations {
            UIView.animate(withDuration: animation.duration,
                           animations: { 
                            animation.closure(self)
            },
                           completion: { _ in
                            animationHandler()
            })
        }
    }
}

public extension Animation {
    public static func fadeIn(duration: TimeInterval = 0.3) -> Animation {
        return Animation(duration: duration,
                         closure: { $0.alpha = 1 })
    }
    
    static func fadeOut(duration: TimeInterval = 0.3) -> Animation {
        return Animation(duration: duration) { $0.alpha = 0 }
    }
    
    public static func resize(to size: CGSize, duration: TimeInterval = 0.3) -> Animation {
        return Animation(duration: duration,
                         closure: { $0.bounds.size = size } )
    }
    
    static func move(byX x: CGFloat, y: CGFloat, duration: TimeInterval = 0.3) -> Animation {
        return Animation(duration: duration) {
            $0.center.x += x
            $0.center.y += y
        }
    }
}

/*
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
*/

public func animate(_ tokens: [AnimationToken]) {
    guard !tokens.isEmpty else {
        return
    }
    
    var tokens: [AnimationToken] = tokens
    let token: AnimationToken = tokens.removeFirst()
    
    token.perform {
        animate(tokens)
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

let secondView: UIView = UIView(frame: debugFrame)
secondView.backgroundColor = .lightGray
secondView.center.x = debugView.center.x + 100

view.addSubview(secondView)

animate([
    debugView.animate([
        .fadeIn(duration: 2.5),
        .resize(to: CGSize(width: 250.0, height: 250.0),
                duration: 2.5)
        ]),
    secondView.animate([
        .move(byX: 100, y: 10, duration: 2.5)
        ])
    ])

/*
debugView.animate(inParallel: [
    .fadeIn(duration: 2.5),
    .resize(to: CGSize(width: 250.0, height: 250.0),
            duration: 2.5)
    ])
*/