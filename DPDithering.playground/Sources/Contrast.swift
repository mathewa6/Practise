import Foundation

extension RGBA {
    /// Returns Int tuple (R, G, B)
    public var averageColors: (Int, Int, Int) {
        var totalRed = 0, totalGreen = 0, totalBlue = 0
        
        for y in 0..<self.height {
            for x in 0..<self.width {
                
                let pixel = self[x, y]
                totalRed += Int(pixel.red)
                totalGreen += Int(pixel.green)
                totalBlue += Int(pixel.blue)
            }
        }
        
        let totalPixels = self.pixels.count //rgba.width * rgba.height
        
        return (totalRed/totalPixels, totalGreen/totalPixels, totalBlue/totalPixels)
    }
}

public func contrast(_ rgba: RGBA) -> RGBA {
    var contrastRGBA: RGBA = rgba
    
    let averages = contrastRGBA.averageColors
    
    for y in 0..<contrastRGBA.height {
        for x in 0..<contrastRGBA.width {
            var pixel = contrastRGBA[x, y]
            let redDelta = Int(pixel.red) - averages.0
            let greenDelta = Int(pixel.green) - averages.1
            let blueDelta = Int(pixel.blue) - averages.2
            pixel.red = UInt8(max(min(255, averages.0 + 3 * redDelta), 0))
            pixel.green = UInt8(max(min(255, averages.1 + 3 * greenDelta), 0))
            pixel.blue = UInt8(max(min(255, averages.2 + 3 * blueDelta), 0))
            contrastRGBA[x, y] = pixel
        }
    }
    
    return contrastRGBA
}

public func grayscale(_ rgba: RGBA) -> RGBA {
    var grayRGBA: RGBA = rgba
    
    for y in 0..<grayRGBA.height {
        for x in 0..<grayRGBA.width {
            var pixel = grayRGBA[x, y]
            
            let grayscale = (Int(pixel.red) + Int(pixel.green) + Int(pixel.blue))/3
            
            pixel.red = UInt8(grayscale)
            pixel.green = UInt8(grayscale)
            pixel.blue = UInt8(grayscale)
            
            grayRGBA[x, y] = pixel
        }
    }
    
    return grayRGBA

}

public func ditherSimple(_ rgba: RGBA) -> RGBA {
    var ditheredRGBA: RGBA = rgba
    var previousError = 0
    
    for y in 0..<ditheredRGBA.height {
        for x in 0..<ditheredRGBA.width {
            var pixel = rgba[x, y]
            
            //Calculate the grayscale by R+G+B/3 for each pixel
            var grayscale = (Int(pixel.red) + Int(pixel.green) + Int(pixel.blue))/3
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
            
            //Set to black or white
            pixel.red = UInt8(diffusedPixel)
            pixel.green = UInt8(diffusedPixel)
            pixel.blue = UInt8(diffusedPixel)
            
            ditheredRGBA[x, y] = pixel
        }
    }
    
    return ditheredRGBA
}
