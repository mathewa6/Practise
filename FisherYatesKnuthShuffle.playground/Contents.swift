import Foundation

// Borrowed from http://stackoverflow.com/questions/24132399/how-does-one-make-random-number-between-range-for-arc4random-uniform
func random(range: Range<Int> ) -> Int {
    var offset = 0
    
    if range.lowerBound < 0   // allow negative ranges
    {
        offset = abs(range.lowerBound)
    }
    
    let lower = UInt32(range.lowerBound + offset)
    let upper = UInt32(range.upperBound   + offset)
    
    return Int(lower + arc4random_uniform(upper - lower)) - offset
}

func shuffleFisherYates(array: [Int]) -> [Int] {
    
    var shuffledArray = array
    for idx in 0 ..< array.count {
        let randomIndex = random(range: idx ..< array.count)
        // Int(arc4random_uniform(UInt32(array.count - idx))) + idx
        (shuffledArray[idx], shuffledArray[randomIndex]) = (shuffledArray[randomIndex], shuffledArray[idx])
    }
    
    return shuffledArray
}

let test = [1, 3, 5, 7, 9, 11, 13, 15, 17]

shuffleFisherYates(array: test)