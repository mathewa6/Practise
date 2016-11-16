import UIKit

/**
 [ericasadun.com]:
 http://ericasadun.com/2014/06/23/swift-spiroswiftograph/ "swiftograph"
 [alanduncan.me]:
 http://alanduncan.me/2014/08/17/swift-spirograph/ "spirograph"
 
 THE FOLLOWING CODE IS NOT MY OWN. IT IS MY REIMPLEMENTATION OF ERICA SADUN'S AND ALAN DUNCANS CODE TO WORK
 IN SWIFT 3.
 - note : PLEASE SEE
 
 [ericasadun.com]

 [alanduncan.me]
 */
struct SpirographGenerator: IteratorProtocol, CustomPlaygroundQuickLookable {
    
    var offset, dTheta, dR, minorRadius, majorRadius: Double
    var theta = 0.0
    
    init(majorRadius: Double, minorRadius: Double, offset: Double, samples: Double) {
        self.offset = offset
        self.dTheta = M_PI * (2.0/samples)
        self.majorRadius = majorRadius
        self.minorRadius = minorRadius
        self.dR = majorRadius - minorRadius
    }
    
    mutating func next() -> CGPoint? {
        let xT: Double = dR * cos(theta) + offset * cos(dR * theta/minorRadius)
        let yT: Double = dR * sin(theta) + offset * sin(dR * theta/minorRadius)
        
        theta += dTheta
        
        return CGPoint(x: CGFloat(xT), y: CGFloat(yT))
    }
    
    
    /// To be able to use Erica's next() function without mutating theta(so that it can be used in PlaygroundQuickLook), the trivial fix is to use one that returns updated theta values.
    ///
    /// - Parameters:
    ///   - currentTheta: Updated values of theta.
    ///   - d: dTheta
    /// - Returns: A tuple of (CGPoint?, newTheta)
    func next(currentTheta: Double, d: Double) -> (CGPoint?, Double) {
        let xT: Double = dR * cos(currentTheta) + offset * cos(dR * currentTheta/minorRadius)
        let yT: Double = dR * sin(currentTheta) + offset * sin(dR * currentTheta/minorRadius)
        
        return (CGPoint(x: CGFloat(xT), y: CGFloat(yT)), currentTheta + d)
    }
    
    var customPlaygroundQuickLook: PlaygroundQuickLook {
        let dimension_2:CGFloat = 125
        let n = 20
        let iterations = 15

        let size = CGSize(width: dimension_2 * 2, height: dimension_2 * 2)
        
        UIGraphicsBeginImageContext(size)
        let ctx = UIGraphicsGetCurrentContext()
        var t = theta
        for i in 0...iterations*n {
            let p: CGPoint?
            (p, t) = next(currentTheta: t, d: dTheta)
            if i == 0 {
                ctx!.move(to: CGPoint(x: p!.x+dimension_2, y: p!.y+dimension_2))
            }
            else {
                ctx!.addLine(to: CGPoint(x: p!.x+dimension_2, y: p!.y+dimension_2))
            }
            
        }
        ctx!.strokePath()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return .image(image!)
    }
}

let sampleSize = 25
let (majorR, minorR) = (25.0, -47.0)

var spiro = SpirographGenerator(majorRadius: majorR,
                                minorRadius: minorR,
                                offset: 25,
                                samples: Double(sampleSize))