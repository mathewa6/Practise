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
struct SpirographGenerator: IteratorProtocol {
    
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
}