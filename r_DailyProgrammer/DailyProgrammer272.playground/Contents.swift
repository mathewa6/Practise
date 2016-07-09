//: # DP272Intermediate
//: ## https://redd.it/4paxp4
//: ---

import UIKit

//http://mhorga.org/2015/10/05/image-processing-in-ios.html

let image = UIImage(named: "imageLarge")!
//let rgba = RGBA(image: image)
//let xrgba = RGBA(image: image)
let yrgba = RGBA(image: image)

//let new = rgba?.toImage()
//let simple = ditherSimple(rgba!).toImage()
//let fs = ditherFloydSteinberg(xrgba!).toImage()

let bs = ditherBayer(yrgba!).toImage()


class Matrix<T>  {
    var rows: [[T]] = []
    
}