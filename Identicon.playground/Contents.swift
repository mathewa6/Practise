import UIKit

public extension UIColor {
    class func randomNormalizedColor() -> UIColor {
        let hue: CGFloat = CGFloat(arc4random_uniform(256))/255
        let sat: CGFloat = CGFloat(arc4random_uniform(128))/255 + 0.5
        let bri: CGFloat = CGFloat(arc4random_uniform(128))/255 + 0.5
        
        return UIColor(hue: hue,
                       saturation: sat,
                       brightness: bri,
                       alpha: 1.0)
    }
}

public extension CGColor {
    static func color(from number: UInt16) -> CGColor {
        let blue = CGFloat(number & 0b11111) / 31;
        let green = CGFloat((number >> 5) & 0b11111) / 31;
        let red = CGFloat((number >> 10) & 0b11111) / 31;
        
        return CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [ red, green, blue, 1 ])!
    }
}

public class GitHubIdenticon {
    private let numberOfColumns = 5
    private let numberOfColumnComponents = 5
    
    private let numberOfRows = 5
    private let numberOfRowComponents = 5
    
    public let size: CGSize = CGSize(width: 88, height: 88)
    
    public init() {}
    
    public func identity(using value: Int, withRows rows: Int, columns: Int) -> CGImage {
        let context = CGContext(
            data: nil,
            width: Int(size.width),
            height: Int(size.height),
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
            )!
        context.setShouldAntialias(false)
        
        let color = UIColor.randomNormalizedColor().cgColor
        context.setFillColor(color)
        
        let cellSize = CGSize(width: size.width / CGFloat(rows), height: size.height / CGFloat(columns));
        
        for row in 0..<rows {
            for col in 0..<columns - columns/2 {
                let offset = Int(row * columns + col)
                if ((value >> offset) & 0b1) == 0 {
                    continue
                }
                
                if row == 0 || row == rows - 1 {
                    if col == 0 || col == columns - 1 {
                        continue
                    }
                }
                
                var rects = [CGRect]()
                rects.append(self.rect(forRow: row, column: col, size: cellSize))
                
                let mirroredCol = (columns - col - 1)
                if (mirroredCol > col) {
                    rects.append(self.rect(forRow: row, column: mirroredCol, size: cellSize))
                }
                context.fill(rects)
            }
        }
        let image = context.makeImage()!
        
        return image
    }
    
    public func icon(from number: Int, size: CGSize) -> CGImage {
        let context = CGContext(
            data: nil,
            width: Int(size.width),
            height: Int(size.height),
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
            )!
        context.setShouldAntialias(false)
        
        let color = UIColor.randomNormalizedColor().cgColor
        context.setFillColor(color)
        
        let cellSize = CGSize(width: size.width / CGFloat(numberOfRows), height: size.height / CGFloat(numberOfColumns));
        
        for row in 0..<numberOfRowComponents {
            for col in 0..<numberOfColumnComponents {
                let offset = Int(row * numberOfColumns + col)
                if ((number >> offset) & 0b1) == 0 {
                    continue
                }
                
                var rects = [CGRect]()
                rects.append(self.rect(forRow: row, column: col, size: cellSize))
                
                let mirroredCol = (numberOfColumns - col - 1)
                if (mirroredCol > col) {
                    rects.append(self.rect(forRow: row, column: mirroredCol, size: cellSize))
                }
                context.fill(rects)
            }
        }
        let image = context.makeImage()!
        
        return image
    }
    
    public func generated() {
        UIGraphicsBeginImageContext(CGSize(width:5,height:5))
        
        guard let g = UIGraphicsGetCurrentContext() else {
            return
        }
        
        var t = 0,
        c = UIColor(hue:CGFloat(drand48()),saturation:1,brightness:1,alpha:1).cgColor
        
        srand48(time(&t))
        
        
        for x in 0..<3 {
            for y in 0..<5 {
                g.setFillColor(drand48()>0.5 ? c : UIColor.white.cgColor)
                
                var r = [CGRect(x:x,y:y,width:1,height:1)]
                
                if x<2 {
                    let m = x==0 ? 4 : 3;
                    r.append(CGRect(x:m,y:y,width:1,height:1))
                }
                
                g.fill(r)
            }
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
    }
    
    private func rect(forRow row: Int, column: Int, size: CGSize) -> CGRect {
        return CGRect(
            x: CGFloat(column) * size.width,
            y: CGFloat(row) * size.height,
            width: size.width,
            height: size.height
        )
    }
}

let str = "E1BF043B"
let num = Int(exactly: str.hash)!

for char in str.characters {
    print(char.description.hash % 2)
}

var truths: [Int] = []

Array(str.characters).map { truths.append( $0.description.hash % 2 == 0 ? 1 : 0)}
truths
// Array(str.characters)[4].description.hash

let x = GitHubIdenticon()
UIImage(cgImage: x.icon(from: num, size: CGSize(width: 44, height: 44)))
UIImage(cgImage: x.identity(using: num, withRows: 5, columns: 5))

x.generated()

class IdentityView: UIView {
    public let text: String = "AZBF043BE1B"
    
    override func draw(_ rect: CGRect) {
        guard let g: CGContext = UIGraphicsGetCurrentContext() else {
            return
        }
        
        let cellSize = CGSize(width: rect.width / CGFloat(5), height: rect.height / CGFloat(5))
        
        var t = 0,
        c = UIColor(hue:CGFloat(drand48()),saturation:1,brightness:1,alpha:1).cgColor
        
        
        for x in 0..<3 {
            for y in 0..<5 { // limit less than text.length
                g.setFillColor( drand48() > 0.5 ? c : UIColor.white.cgColor)
                
                var r = [CGRect(x: CGFloat(x) * cellSize.width,
                                y: CGFloat(y) * cellSize.height,
                                width: cellSize.width,
                                height: cellSize.height)]
                
                if x<2 {
                    let m = x==0 ? 4 : 3;
                    r.append(CGRect(x: CGFloat(m) * cellSize.width,
                                    y: CGFloat(y) * cellSize.height,
                                    width: cellSize.width,
                                    height: cellSize.height))
                }
                
                g.fill(r)
            }
        }
        
    }
}

let v = IdentityView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
