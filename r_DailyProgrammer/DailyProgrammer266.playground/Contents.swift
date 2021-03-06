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

func generateAdjacencyMatrix(data: Dictionary<Int, [Int]>) -> [[Int]] {
    var matrix = [[Int]](count: data.keys.count, repeatedValue: [Int](count: data.keys.count, repeatedValue: 0))
    
    for i in 1...data.keys.count {
        let line = data[i]!
        for element in line {
            matrix[i - 1][element - 1] = 1
        }
    }
    
    return matrix
}

func readFile(withName name: String) -> String? {
    let splits = name.characters.split(".")
    let path = NSBundle.mainBundle().pathForResource(String(splits.first!), ofType: String(splits.last!))
    let content = NSFileManager.defaultManager().contentsAtPath(path!)
    
    return String(data: content!, encoding: NSUTF8StringEncoding)
}


//let test = Pair(line: "1 16")
//let arrayTest = [Pair(line: "1 2"), Pair(line: "1 3")]
//let d = calculateGraphDegrees(3, pairs: arrayTest)
//generateAdjacencyMatrix(d)
//getDegree(d)
//let dir = XCPSharedDataDirectoryPath

let input: String = readFile(withName: "input.txt")!
let lines = input.characters.split("\n")

var dataArray: [Pair] = []
var total: Int = 0
for (i, line) in lines.enumerate() {
    if i == 0 {
        total = Int(String(line))!
    } else {
        dataArray.append(Pair(line: String(line)))
    }
}

let answer = calculateGraphDegrees(total, pairs: dataArray)
getDegree(answer)
generateAdjacencyMatrix(answer)