//: # DP261Easy
//: ## https://redd.it/4dccix
//: ---

import Foundation

let test = [8, 1, 6, 3, 5, 7, 4, 9, 2]

func isMagicSqaure(squareArray: Array<Int>, withSum sum: Int) -> Bool {
    
    let rowLength = Int(sqrt(Double(test.count)))
    var rowSum = sum
    var rowCount = rowLength

    for (i, element) in squareArray.enumerate() {
        rowSum -= element
        rowCount -= 1
        if rowCount == 0 {
            if rowSum != 0 {
                return false
            } else {
                rowSum = sum
                rowCount = rowLength
            }
        }
    }
    
    return true
}

isMagicSqaure(test, withSum: 15)