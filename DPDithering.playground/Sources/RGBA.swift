import UIKit

public struct Coordinate: CustomStringConvertible {
    var x: Int
    var y: Int
    
    public var description: String {
        return "AddressingCoordinate: (\(x), \(y))"
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
    
    public var description: String {
        return "Pixel: \(value)"
    }
}

public struct RGBA: CustomStringConvertible {
    // MARK: - Public properties
    public var pixels: UnsafeMutableBufferPointer<Pixel>
    public var width: Int
    public var height: Int
    
    // MARK: - Private methods
    private func createContext(withWidth width: Int,
                               height: Int,
                               data: UnsafeMutablePointer<Pixel>) -> CGContext? {
        let bitsPerComponent = 8
        let bytesPerPixel = 4
        let bytesPerRow = width * bytesPerPixel
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        var bitMapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue
        bitMapInfo |= CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        
        guard let imageContext = CGContext(data: data,
                                           width: width,
                                           height: height,
                                           bitsPerComponent: bitsPerComponent,
                                           bytesPerRow: bytesPerRow,
                                           space: colorSpace,
                                           bitmapInfo: bitMapInfo) else { return nil }
        
        return imageContext
    }
    
    // MARK: - Public methods
    public var description: String {
        return "(\(width), \(height)), \(width*height)"
    }
    
    // MARK: UIImage conversion
    public init?(image: UIImage) {
        guard let cgImage = image.cgImage else { return nil }
        
        self.width = Int(image.size.width)
        self.height = Int(image.size.height)
        
        let imageData = UnsafeMutablePointer<Pixel>.allocate(capacity: width * height)
        self.pixels = UnsafeMutableBufferPointer<Pixel>(start: imageData, count: width * height)
        
        guard let imageContext: CGContext = self.createContext(withWidth: self.width,
                                                               height: self.height,
                                                               data:imageData) else { return nil }
        
        imageContext.draw(cgImage, in: CGRect(origin: CGPoint.zero, size: image.size))
        
    }
    
    public func toImage() -> UIImage? {
        guard let imageData: UnsafeMutablePointer<Pixel> = self.pixels.baseAddress else {
            return nil
        }
        
        guard let imageContext = self.createContext(withWidth: self.width,
                                                    height: self.height,
                                                    data: imageData) else { return nil }
        
        guard let cgImage = imageContext.makeImage() else { return nil }
        
        let image = UIImage(cgImage: cgImage)
        
        return image
        
    }
    
    // MARK:- Subscripting
    
    subscript(coordinate: Coordinate) -> Pixel {
        get {
            let idx: Int = coordinate.y * self.width + coordinate.x
            return self.pixels[idx]
        }
        
        set {
            let idx: Int = coordinate.y * self.width + coordinate.x
            self.pixels[idx] = newValue
        }
    }
    
    subscript(x: Int, y: Int) -> Pixel {
        get {
            let idx: Int = y * self.width + x
            return self.pixels[idx]
        }
        
        set {
            let idx: Int = y * self.width + x
            self.pixels[idx] = newValue
        }
    }
}
