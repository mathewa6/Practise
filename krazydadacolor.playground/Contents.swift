import UIKit
import PlaygroundSupport

// Inspired by https://krazydad.com/tutorials/makecolors.php

let frame: CGRect = CGRect(x: 0.0,
                           y: 0.0,
                           width: 750.0,
                           height: 37.5)
let mainView: UIView = UIView(frame: frame)
mainView.backgroundColor = .white


var frequency: CGFloat = 2 * .pi/40
var amplitude: CGFloat = 128
var center: CGFloat = 127

let count = 20

for i in 0..<count {
    let dim: CGFloat = frame.width/CGFloat(count)
    
    let subFrame: CGRect = CGRect(x: CGFloat(i) * dim,
                                  y: 0,
                                  width: dim,
                                  height: 37.5)
    let tinyView: UIView = UIView(frame: subFrame)
    
    let phaseDefault: CGFloat = .pi/3
    
    let vr: CGFloat = CGFloat(((sin((frequency * CGFloat(i) + (0 * phaseDefault)))) * amplitude) + center)/255.0
    let vg: CGFloat = CGFloat(((sin((frequency * CGFloat(i) + (2 * phaseDefault)))) * amplitude) + center)/255.0
    let vb: CGFloat = CGFloat(((sin((frequency * CGFloat(i) + (4 * phaseDefault)))) * amplitude) + center)/255.0
    
    let color: UIColor = UIColor(red: vr,
                                 green: vg,
                                 blue: vb,
                                 alpha: 1.0)
    
    tinyView.backgroundColor = color
    mainView.addSubview(tinyView)
}
mainView
PlaygroundPage.current.liveView = mainView

let x = UIImage(view: mainView)

let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
let filePath = "\(paths[0])/colorstair.png"

print(filePath)

let data: Data = UIImagePNGRepresentation(x)!
do {
    let url: URL = URL(fileURLWithPath: filePath)
    try data.write(to: url)
} catch let error as NSError {
    print(error)
}
extension UIImage {
    convenience init(view: UIView) {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, 0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage)!)
    }
}

public struct DXLColorComponents {
    var red: CGFloat
    var green: CGFloat
    var blue: CGFloat
    var alpha: CGFloat
}

extension UIColor {
    
    public var components: DXLColorComponents {
        let componentArray: [CGFloat] = self.cgColor.components ?? [1, 1]
        if componentArray.count == 2 {
            return DXLColorComponents(red: componentArray[0],
                                      green: componentArray[0],
                                      blue: componentArray[0],
                                      alpha: componentArray[1])
        } else {
            return DXLColorComponents(red: componentArray[0],
                                      green: componentArray[1],
                                      blue: componentArray[2],
                                      alpha: componentArray[3])
        }
    }
    
    static func generateColorSequence(length: Int) -> [UIColor] {
        var frequency: CGFloat = 0.1
        var amplitude: CGFloat = 128
        var center: CGFloat = 127
        var returnArray: [UIColor] = []
        for i in 0..<length {
            let phaseDefault: CGFloat = .pi/3
            
            let vr: CGFloat = CGFloat(((sin((frequency * CGFloat(i) + (0 * phaseDefault)))) * amplitude) + center)/255.0
            let vg: CGFloat = CGFloat(((sin((frequency * CGFloat(i) + (2 * phaseDefault)))) * amplitude) + center)/255.0
            let vb: CGFloat = CGFloat(((sin((frequency * CGFloat(i) + (4 * phaseDefault)))) * amplitude) + center)/255.0
            
            let color: UIColor = UIColor(red: vr,
                                         green: vg,
                                         blue: vb,
                                         alpha: 1.0)
            
            returnArray.append(color)
        }
        return returnArray
    }
    
    static public func generateColorSequence(from firstColor: UIColor,
                                             to secondColor: UIColor,
                                             withLength length: Int) -> [UIColor] {
        var returnArray: [UIColor] = []
        for i in 0..<length {
            
            let color: UIColor = firstColor.lerp(to: secondColor,
                                                 fraction: CGFloat(i+1)/CGFloat(length))
            
            returnArray.append(color)
        }
        return returnArray
        
    }
    
    public func lerp(to color: UIColor, fraction: CGFloat) -> UIColor {
        fraction
        var frac: CGFloat = max(0, fraction)
        frac = min(1, fraction)
        
        let fromComponents: DXLColorComponents = self.components
        let toComponents: DXLColorComponents = color.components
        
        let red: CGFloat = fromComponents.red + (toComponents.red - fromComponents.red) * frac
        let green: CGFloat = fromComponents.green + (toComponents.green - fromComponents.green) * frac
        let blue: CGFloat = fromComponents.blue + (toComponents.blue - fromComponents.blue) * frac

        let alpha: CGFloat = fromComponents.alpha + (toComponents.alpha - fromComponents.alpha) * frac

        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
        
    }
    
    public func lerpHSB(to color: UIColor, fraction: CGFloat) -> UIColor {
        fraction
        var frac: CGFloat = max(0, fraction)
        frac = min(1, fraction)
        
        var h1: CGFloat = 0, s1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
        self.getHue(&h1, saturation: &s1, brightness: &b1, alpha: &a1)
        
        var h2: CGFloat = 0, s2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0
        color.getHue(&h2, saturation: &s2, brightness: &b2, alpha: &a2)
        
        let hue: CGFloat = h1 + (h2 - h1) * frac
        let saturation: CGFloat = s1 + (s2 - s1) * frac
        let brightness: CGFloat = b1 + (b2 - b1) * frac
        let alpha: CGFloat = a1 + (a2 - a1) * frac
        
        return UIColor(hue: hue,
                       saturation: saturation,
                       brightness: brightness,
                       alpha: alpha)
    }
}

UIColor.generateColorSequence(length: 20)
UIColor.generateColorSequence(from: .white, to: .black, withLength: 10)

