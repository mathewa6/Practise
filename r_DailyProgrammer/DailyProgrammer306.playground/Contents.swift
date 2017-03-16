//: # DP306Intermediate
//: ## https://redd.it/5zj7e4
//: ---

import Foundation

infix operator **   : MultiplicationPrecedence
infix operator **=  : MultiplicationPrecedence

func ** (left: Double, right: Double) -> Double {
    return pow(left, right)
}

func **= ( left: inout Double, right: Double) {
    left = pow(left, right)
}

let original = ["0", "1"]
let m: Int = Int(2 ** 1)

for i in 0 ..< m {
    let a = original.reversed()[i]
    print(i)
}