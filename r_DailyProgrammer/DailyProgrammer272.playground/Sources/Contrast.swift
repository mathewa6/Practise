import Foundation
import UIKit

public struct Coordinate: CustomStringConvertible {
    var x: Int
    var y: Int
    
    public var description: String {
        return "(\(x), \(y))"
    }
}

public struct Pixel: CustomStringConvertible {
    public var value: UInt32
    
    public var red: UInt8 {
        get {
            return UInt8(value & 0xFF)
        }
        set {
            value = UInt32(newValue) | (value & 0xFFFFFF00)
        }
    }
    
    public var green: UInt8 {
        get {
            return UInt8(value >> 8 & 0xFF)
        }
        set {
            value = (UInt32(newValue) << 8) | (value & 0xFFFF00FF)
        }
    }
    
    public var blue: UInt8 {
        get {
            return UInt8(value >> 16 & 0xFF)
        }
        set {
            value = (UInt32(newValue) << 16) | (value & 0xFF00FFFF)
        }
    }
    
    public var alpha: UInt8 {
        get {
            return UInt8(value >> 24 & 0xFF)
        }
        set {
            value = (UInt32(newValue) << 24) | (value & 0x00FFFFFF)
        }
    }
    
    public var grayscale: Int {
        get {
            return (Int(self.red) + Int(self.green) + Int(self.blue))/3
        }
        
        set {
            var value = newValue
            if value > 255 {
                value = 255
            } else if value < 0 {
                value = 0
            }
            
            self.red = UInt8(value)
            self.green = UInt8(value)
            self.blue = UInt8(value)
        }
    }
    
    public var description: String {
        return "Pixel : \(value)"
    }
}

public struct RGBA: CustomStringConvertible {
    public var pixels: UnsafeMutableBufferPointer<Pixel>
    public var width: Int
    public var height: Int
    
    public init?(image: UIImage) {
        guard let cgImage = image.CGImage else { return nil }
        
        width = Int(image.size.width)
        height = Int(image.size.height)
        
        let bitsPerComponent = 8
        let bytesPerPixel = 4
        let bytesPerRow = width * bytesPerPixel
        let imageData = UnsafeMutablePointer<Pixel>.alloc(width * height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        var bitMapInfo: UInt32 = CGBitmapInfo.ByteOrder32Big.rawValue
        bitMapInfo |= CGImageAlphaInfo.PremultipliedLast.rawValue & CGBitmapInfo.AlphaInfoMask.rawValue
        guard let imageContext = CGBitmapContextCreate(imageData, width, height, bitsPerComponent, bytesPerRow, colorSpace, bitMapInfo) else { return nil }
        CGContextDrawImage(imageContext, CGRect(origin: CGPointZero, size: image.size), cgImage)
        
        pixels = UnsafeMutableBufferPointer<Pixel>(start: imageData, count: width * height)
    }
    
    public func toImage() -> UIImage? {
        let bitsPerComponent = 8
        let bytesPerPixel = 4
        let bytesPerRow = width * bytesPerPixel
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        var bitMapInfo: UInt32 = CGBitmapInfo.ByteOrder32Big.rawValue
        bitMapInfo |= CGImageAlphaInfo.PremultipliedLast.rawValue & CGBitmapInfo.AlphaInfoMask.rawValue
        
        guard let imageContext = CGBitmapContextCreateWithData(pixels.baseAddress, width, height, bitsPerComponent, bytesPerRow, colorSpace, bitMapInfo, nil, nil) else { return nil }
        guard let cgImage = CGBitmapContextCreateImage(imageContext) else { return nil }
        let image = UIImage(CGImage: cgImage)
        
        return image
        
    }
    
    public var description: String {
        return "(\(width), \(height)), \(width*height)"
    }
    
    public subscript(index: (Int, Int)) -> Pixel {
        get {
            let position = index.1 * width + index.0
            return pixels[position]
        }
        set {
            let position = index.1 * width + index.0
            pixels[position] = newValue
        }
    }
}

public func findAverageColors(rgba: RGBA) -> (Int, Int, Int) {
    var totalRed = 0, totalGreen = 0, totalBlue = 0
    
    for y in 0..<rgba.height {
        for x in 0..<rgba.width {
            let index = y * rgba.width + x
            let pixel = rgba.pixels[index]
            totalRed += Int(pixel.red)
            totalGreen += Int(pixel.green)
            totalBlue += Int(pixel.blue)
        }
    }
    
    let totalPixels = rgba.pixels.count //rgba.width * rgba.height
    
    return (totalRed/totalPixels, totalGreen/totalPixels, totalBlue/totalPixels)
}

public func contrast(rgba: RGBA) -> RGBA {
    let averages = findAverageColors(rgba)
    
    for y in 0..<rgba.height {
        for x in 0..<rgba.width {
            let index = y * rgba.width + x
            var pixel = rgba.pixels[index]
            let redDelta = Int(pixel.red) - averages.0
            let greenDelta = Int(pixel.green) - averages.1
            let blueDelta = Int(pixel.blue) - averages.2
            pixel.red = UInt8(max(min(255, averages.0 + 3 * redDelta), 0))
            pixel.green = UInt8(max(min(255, averages.1 + 3 * greenDelta), 0))
            pixel.blue = UInt8(max(min(255, averages.2 + 3 * blueDelta), 0))
            rgba.pixels[index] = pixel
        }
    }
    
    return rgba
}

public func grayscale(rgba: RGBA) -> RGBA {
    for y in 0..<rgba.height {
        for x in 0..<rgba.width {
            let index = y * rgba.width + x
            var pixel = rgba.pixels[index]
            
            let grayscale = (Int(pixel.red) + Int(pixel.green) + Int(pixel.blue))/3
            
            pixel.red = UInt8(grayscale)
            pixel.green = UInt8(grayscale)
            pixel.blue = UInt8(grayscale)
            
            rgba.pixels[index] = pixel
        }
    }
    
    return rgba

}

public func ditherSimple(imageData: RGBA) -> RGBA {
    var rgba = imageData
    var previousError = 0
    
    for y in 0..<rgba.height {
        for x in 0..<rgba.width {
            var pixel = rgba[x,y]
            
            //Calculate the grayscale by R+G+B/3 for each pixel
            var grayscale = pixel.grayscale
            grayscale += previousError
            
            var diffusedPixel = 0
            
            //Check if that value is closer to 0 or 255
            if grayscale < 128 {
                diffusedPixel = 0
            } else {
                diffusedPixel = 255
            }
            
            //Update Error
            previousError = grayscale - diffusedPixel
            
            rgba[x,y].grayscale = diffusedPixel
        }
    }
    
    return rgba
}

func set(inout pixel: Pixel, toValue value: Int) {
    pixel.red = UInt8(value)
    pixel.green = UInt8(value)
    pixel.blue = UInt8(value)
}

public func ditherFloydSteinberg(imageData: RGBA) -> RGBA {
    var rgba = imageData
    var previousError = 0
    
    for y in 0..<rgba.height {
        for x in 0..<rgba.width {
            var pixel = rgba[x,y]
            
            var diffusedPixel = 0
            
            //Check if that value is closer to 0 or 255
            if pixel.grayscale < 128 {
                diffusedPixel = 0
            } else {
                diffusedPixel = 255
            }
            
            //Update Error
            previousError = pixel.grayscale - diffusedPixel
            
            rgba[x,y].grayscale = diffusedPixel
            if x < rgba.width - 1 {
//                print(rgba[((x+1), y)].grayscale, x, y, Int(Double(previousError) * (7.0/16)))
                rgba[((x+1), y)].grayscale += Int(Double(previousError) * (7.0/16))
            }
            
            if x > 0 && y < rgba.height - 1 {
                rgba[(x-1, y+1)].grayscale += Int(Double(previousError) * (3.0/16))
            }
            
            if y < rgba.height - 1 {
                rgba[(x, y+1)].grayscale += Int(Double(previousError) * (5.0/16))
            }
            
            if x < rgba.width - 1 && y < rgba.height - 1 {
                rgba[(x+1, y+1)].grayscale += Int(Double(previousError) * (1.0/16))
            }
        }
    }
    
    return rgba
}