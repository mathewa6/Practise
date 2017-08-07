import UIKit
import PlaygroundSupport

// Inspired by https://krazydad.com/tutorials/makecolors.php

let frame: CGRect = CGRect(x: 0.0,
                           y: 0.0,
                           width: 750.0,
                           height: 750.0)
let mainView: UIView = UIView(frame: frame)
mainView.backgroundColor = .white


var frequency: CGFloat = 0.1
var amplitude: CGFloat = 128
var center: CGFloat = 127

let count = 20

for i in 0..<count {
    let dim: CGFloat = frame.width/CGFloat(count)
    
    let subFrame: CGRect = CGRect(x: CGFloat(i) * dim,
                                  y: CGFloat(i) * dim,
                                  width: dim,
                                  height: frame.height/CGFloat(count))
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

extension UIColor {
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
}

UIColor.generateColorSequence(length: 20)

