//: # DP266Easy
//: ## https://redd.it/4ijtrt
//: ---

import Foundation
import XCPlayground

class Pair: CustomStringConvertible {
    var a: Int = 0
    var b: Int = 0
    
    init(a: Int, b: Int) {
        self.a = a
        self.b = b
    }
    
    convenience init(line: String, separator: String = " ") {
        let splits = line.componentsSeparatedByString(separator)
        self.init(a: Int(splits.first!)!, b: Int(splits.last!)!)
    }
    
    convenience init () {
        self.init(a: 0, b: 0)
    }
    
    var description: String {
        return "\(a) <---> \(b)"
    }
}

let test = Pair(line: "1 16")
let arrayTest = [Pair(line: "1 2"), Pair(line: "1 3")]

func calculateGraphDegrees(total: Int, pairs: [Pair]) -> Dictionary<Int, [Int]> {
    var degreeDictionary: [Int: [Int]] = Dictionary<Int, [Int]>()
    
    for i in 1...total {
        degreeDictionary[i] = []
    }
    
    if pairs.count > 0 {
        for line in pairs {
            degreeDictionary[line.a]?.append(line.b)
            degreeDictionary[line.b]?.append(line.a)
        }
    }
    
    return degreeDictionary
}

func getDegree(data: Dictionary<Int, [Int]>) {
    for i in 1...data.keys.count { // If we directly use node, order is not guaranteed
        print("Node \(i) has a degree of \(data[i]!.count)")
    }
}

let d = calculateGraphDegrees(3, pairs: arrayTest)
getDegree(d)
let dir = XCPSharedDataDirectoryPath
