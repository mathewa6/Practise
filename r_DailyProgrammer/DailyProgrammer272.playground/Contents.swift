//: # DP272Intermediate
//: ## https://redd.it/4paxp4
//: ---

import UIKit

//http://mhorga.org/2015/10/05/image-processing-in-ios.html

//let image = UIImage(named: "portal.jpg")!
//let rgba = RGBA(image: image)
//let xrgba = RGBA(image: image)
//let yrgba = RGBA(image: image)

//let new = rgba?.toImage()
//let simple = ditherSimple(rgba!).toImage()
//let fs = ditherFloydSteinberg(xrgba!).toImage()

//let bs = ditherBayer(yrgba!).toImage()

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

class Matrix<T>  {
    var rows: [[T]] = []
    
}

func generateBayer(size: Int, input: [[Int]]? = [[0, 2], [3, 1]]) -> [[Int]]{
    
    if input!.count >= size {
        return input!
    }
    
    var output = [[Int]](count: input!.count * 2, repeatedValue: [Int](count: input!.count * 2, repeatedValue: 0))
    
    for (y, row) in output.enumerate() {
        for (x, _) in row.enumerate() {
            let padding = input![x > input!.count/2 ? 1 : 0][y > input!.count/2 ? 1 : 0]
            output[x][y] = 4 * input![x % input!.count][y % input!.count] + padding
        }
    }
    
    return generateBayer(size, input: output)
}

func createThreshold(bayer: [[Int]]) -> [[Int]] {
    var output = [[Int]](count: bayer.count, repeatedValue: [Int](count: bayer.count, repeatedValue: 0))
    
    for (y, row) in bayer.enumerate() {
        for (x, _) in row.enumerate() {
            output[x][y] = 255 * Int(Double(bayer[x][y]) + 0.5)/(bayer.count * bayer.count)
        }
    }
    
    return output
}

let a = generateBayer(4)
let b = createThreshold(a)