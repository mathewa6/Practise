//: # DP261Easy
//: ## https://redd.it/4dccix
//: ---

import Foundation

let test = [8, 1, 6, 3, 5, 7, 4, 9, 2]

func isMagicSqaure(squareArray: Array<Int>, withSum sum: Int) -> Bool {
    
    let rowLength = Int(sqrt(Double(test.count)))
    var rowSum = sum
    var rowCount = rowLength
    
    var colSums = Array<Int>(count: rowLength, repeatedValue: sum)
    
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
        
        let currentColumn = i % rowLength
        colSums[currentColumn] -= element
    }
    
    if colSums.reduce(0, combine: +) != 0 {
        return false
    }

    return true
}

isMagicSqaure(test, withSum: 15)