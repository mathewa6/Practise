import UIKit

let
identiconMix: [String] = [
    "4ADCB1A8-477D-475A-9E58-1A9AABCBF0F1",
    "B46B594B-0891-455C-BB83-839708CB031E",
    "28F6FAA1-8C48-4CDD-A068-38348A3EE98A",
    "211627EF-1AE7-4158-B7CF-A1C582F805C1",
    "330A88AC-93D0-478C-B0AC-C8356B083061",
    "4685658E-F184-4901-AB95-61789DBC3F96",
    "B07C82AC-A8BE-4A92-8F9B-975C520C346B",
    "10C2BBE7-4E47-41EA-8045-4C88B4E34F1A",
    "7AA2D934-BC6C-4F71-9DF6-341D55979011",
    "0FFD8746-D886-4BCB-8AB2-8540E4A65DAE",
    "9FE90ED7-8836-4399-9D9D-C42C313FF348",
    "8BF27D40-D85A-47F0-82D8-3FA9CF7FC2FE",
    "35AEB57A-EAE6-41DD-917F-76F8B4A7EC01",
    "1E41F17F-4F1B-415D-8B2E-C32B8379F613",
    "AA606E02-B806-46C3-B1E8-17192E4A93A1",
    "A809BBE5-858B-4BEE-AFD7-5894D89D6556",
    "7E20BE54-94E3-46EA-92FC-283E919009DB",
    "7EE0061C-7131-4B47-A05B-E5139ACAA922",
    "A42D69D6-5F41-4E75-A09A-E6FDFA46E3EB",
    "BF020678-DCE2-4207-B49E-E2E94577A917",
    "7BEC8FB7-516B-4851-A950-B768283525A6",
    "C2141630-1703-4257-AFC4-E39006CC933E",
    "DC58A155-5DE2-4F83-B080-A827EA1423C6",
    "C0850E86-6092-4849-9041-EF20806BCA28",
    "021838E8-B573-4B47-A81C-E265F34763FA",
    "87B50882-4D99-4E3B-B845-0B90ABB1C5B6",
    "697FA66B-8486-4A7C-A063-5830E2768450",
    "E08837D1-B0FC-4C2C-BB1F-1CCA151DCDD9",
    "514E1DE2-8714-4A66-B381-8E4EAD017F31",
    "3F0FF748-1C92-4201-B4CB-BBBB2368F8B7",
    "ADB689A8-EF03-4C40-BCC7-0DB797030DC2",
    "2B506692-0DF9-4B48-89A0-77E1F51F6E82"
]

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
    
    class var tintMuted: UIColor {
        let factor: Float = 0.66
        return UIColor(red: CGFloat((12/255.0) + factor)/2,
                       green: CGFloat((150/255.0) + factor)/2,
                       blue: CGFloat((75/255.0) + factor)/2,
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
    
    public let size: CGSize = CGSize(width: 600, height: 600)
    
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
        
        var color = UIColor.tintMuted.cgColor
        
        let cellSize = CGSize(width: size.width / CGFloat(rows), height: size.height / CGFloat(columns));
        
        for row in 0..<rows {
            for col in 0..<columns - columns/2 {
                let offset = Int(row * columns + col)
                let digit: Int = (value >> offset)
                if (digit & 0b1) == 0 {
                    continue
                }
                
                if row == 0 || row == rows - 1 {
                    if col == 0 || col == columns - 1 {
                        continue
                    }
                }
                
                color = color.copy(alpha: CGFloat(0.51 + Double((digit & 0b1111))/16.0)) ?? color
                context.setFillColor(color)

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

let str = "211627EF"
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
let image = UIImage(cgImage: x.identity(using: "D441DDE7-27D5-471F-B426-A2A745D400F0".hash, withRows: 5, columns: 5))


// Create path.
let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
let filePath = "\(paths[0])/Identicon.png"

let url: URL = URL(fileURLWithPath: filePath)
print(url.description)

for id in identiconMix {
    let x = GitHubIdenticon()
    UIImage(cgImage: x.icon(from: num, size: CGSize(width: 44, height: 44)))
    let image = UIImage(cgImage: x.identity(using: id.hash, withRows: 5, columns: 5))
    
    
    // Create path.
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let filePath = "\(paths[0])/\(id).png"
    
    let url: URL = URL(fileURLWithPath: filePath)
    print(url.description)

    let
    imageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 600, height: 600))
    imageView.layer.cornerRadius = 7.5
    imageView.backgroundColor = UIColor(red: 235/250,
                                        green: 235/250,
                                        blue: 235/250,
                                        alpha: 1.0)
    imageView.image = image
    
    // Save image.
    do {
        try UIImagePNGRepresentation(image)?.write(to: url)
    } catch let error as NSError {
        print("Error")
    }
}

let
imageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 600, height: 600))
imageView.layer.cornerRadius = 7.5
imageView.backgroundColor = UIColor(red: 235/250,
                                    green: 235/250,
                                    blue: 235/250,
                                    alpha: 1.0)
imageView.image = image

// Save image.
do {
    try UIImagePNGRepresentation(image)?.write(to: url)
} catch let error as NSError {
    print("Error")
}


x.generated()

class IdentityView: UIView {
    public let text: String = "211627EF"
    
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
