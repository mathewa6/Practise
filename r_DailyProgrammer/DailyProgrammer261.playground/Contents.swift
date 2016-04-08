//: # DP261Easy
//: ## https://redd.it/4dccix
//: ---

import Foundation

let test = [8, 1, 6, 7, 5, 3, 4, 9, 2]
/*
 [8, 1, 6, 3, 5, 7, 4, 9, 2] => true
 [2, 7, 6, 9, 5, 1, 4, 3, 8] => true
 [3, 5, 7, 8, 1, 6, 4, 9, 2] => false
 [8, 1, 6, 7, 5, 3, 4, 9, 2] => false
 */

func isMagicSqaure(squareArray: Array<Int>, withSum sum: Int) -> Bool {
    
    let rowLength = Int(sqrt(Double(test.count)))
    var rowSum = sum
    var rowCount = rowLength
    
    var colSums = Array<Int>(count: rowLength, repeatedValue: sum)
    
//    var leftDiag = Set<Int>()
//    var rightDiag = Set<Int>()
//
//    for value in 0..<test.count {
//        let currentRow: Int = value / rowLength
//        
//        if value == (rowLength * currentRow) + currentRow {
//            leftDiag.insert(value)
//        }
//        
//        if value == (rowLength - 1) * (currentRow + 1) {
//            rightDiag.insert(value)
//        }
//    }
    
    var leftDiagSum = sum
    var rightDiagSum = sum
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
        
        let currentRow: Int = i / rowLength
        if i == (rowLength * currentRow) + currentRow {
            leftDiagSum -= element
        }
        if i == (rowLength - 1) * (currentRow + 1) {
            rightDiagSum -= element
        }
    }
    
    if colSums.reduce(0, combine: {abs($0) + abs($1)}) != 0 {
        return false
    }
    
    if leftDiagSum != 0 || rightDiagSum != 0 {
        return false
    }
    
    return true
}

isMagicSqaure(test, withSum: 15)