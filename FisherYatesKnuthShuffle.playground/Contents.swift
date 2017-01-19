import Foundation

func shuffleFisherYates(array: [Int]) -> [Int] {
    
    var shuffledArray = array
    for idx in 0 ..< array.count {
        let random = Int(arc4random_uniform(UInt32(array.count - idx))) + idx
        (shuffledArray[idx], shuffledArray[random]) = (shuffledArray[random], shuffledArray[idx])
    }
    
    return shuffledArray
}

let test = [1, 3, 5, 7, 9, 11, 13, 15, 17]

shuffleFisherYates(array: test)