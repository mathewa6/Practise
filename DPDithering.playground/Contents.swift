
import UIKit

//http://mhorga.org/2015/10/05/image-processing-in-ios.html

let a = 150
let image = UIImage(named: "portal.jpg")!
let rgba = RGBA(image: image)
//let new = rgba?.toImage()

let contrasted = ditherSimple(rgba!).toImage()


//let coordinate = Coordinate(x: 10, y: 32)
//let index = findIndex(coordinate, rgba: rgba!)
//
//var pixel = rgba?.pixels[index]

//let p = Pixel(value: 0x71234567)
//
//let red = UInt8(p.value & 0xFF)
//let green = UInt8(p.value >> 8 & 0xFF)
//let blue = UInt8(p.value >> 16 & 0xFF)
//let alpha = UInt8(p.value >> 24 & 0xFF)

