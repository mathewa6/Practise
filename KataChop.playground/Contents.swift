import Foundation

// A contorted variation of http://codekata.com/kata/kata02-karate-chop/

func chop(_ value: Int, _ list: [Int]) -> Int {
    
    // Checks a subarray for the given value if its count == 1, otherwise
    // returns whether the value might be contained in the subarray's values.
    func checkChop(chop: [Int], value: Int) -> (contained: Bool, nextChop: [Int]?) {
        var returnChop: [Int]?
        
        if chop.count > 0 {
            if chop.count == 1 {
                if chop[0] == value {
                    return (contained: true, nextChop: nil)
                }
            } else {
                returnChop = chop.asRangeCovers(value: value) ? chop : nil
            }
        }
        
        return (contained: false, nextChop: returnChop)
    }
    
    let n = list.count
    let indices = Array(0 ..< n)
    
    // Create two arrays one splitting the original and the other splitting the 'indices'
    // This is so splitx can track the original index of an element if it is what we're looking for.
    // For single element list, the following return nil.
    // The ?? handling can instead just be done inside split()
    var splits = list.split() ?? (left: [1], right: [])
    var splitx = indices.split() ?? (left: [0], right: [])
    
    while splits.left.count > 0 || splits.right.count > 0 {
        var nextSplit: [Int]?
        var nextX: [Int]?
        
        let left = checkChop(chop: splits.left, value: value)
        let right = checkChop(chop: splits.right, value: value)
        
        if left.contained || right.contained {
            return left.contained ? splitx.left.first! : splitx.right.first!
        } else {
            nextSplit = (left.nextChop != nil) ? left.nextChop : right.nextChop
            nextX = (left.nextChop != nil) ? splitx.left : splitx.right
        }
        
        splits = nextSplit?.split() ?? (left: [], right: [])
        splitx =  (nextX?.split()) ??  (left: [], right: [])
    }
    
    return -1
}

func chop(value: Int, list: [Int], l: Int, r: Int) -> Int {
    
    if r >= l {
        let idx = l + ( r - l )/2
        if list[idx] == value {
            return idx
        }
        
        if value < list[idx] {
            return chop(value: value, list: list, l: l, r: idx - 1)
        } else {
            return chop(value: value, list: list, l: idx + 1, r: r)
        }
    }

    
    return -1
}

func chop_iter(value: Int, list: [Int], l: Int, r: Int) -> Int {
    var left = l, right = r
    
    while right >= left {
        let idx = (left + right)/2
        if list[idx] == value {
            return idx
        }
        
        if value < list[idx] {
            right = idx - 1
            continue
        } else {
            left = idx + 1
            continue
        }
    }
    return -1
}

extension Array {
    // Divides the array into two subarrays and returns a tuple (left:, right:) containing them.
    func split() -> (left: [Element], right: [Element])? {
        let n = self.count
        if n == 1 {
            return nil
        }
        let half = n/2
        return (left: Array(self[0 ..< half]), right: Array(self[half ..< n]))
    }
    
    // Returns whether a given sorted array contains a value within
    // the values of its lower and highest elements.
    func asRangeCovers(value: Int) -> Bool {
        return value <= self.last as! Int && value >= self.first as! Int
    }
}

// Test asserts from pragdave.
func test_chop() {
    assert(-1 == chop(3, []))
    assert(-1 == chop(3, [1]))
    assert( 0 == chop(1, [1]))
    
    assert( 0 == chop(1, [1, 3, 5]))
    assert( 1 == chop(3, [1, 3, 5]))
    assert( 2 == chop(5, [1, 3, 5]))
    assert(-1 == chop(0, [1, 3, 5]))
    assert(-1 == chop(2, [1, 3, 5]))
    assert(-1 == chop(4, [1, 3, 5]))
    assert(-1 == chop(6, [1, 3, 5]))
    
    assert( 0 == chop(1, [1, 3, 5, 7]))
    assert( 1 == chop(3, [1, 3, 5, 7]))
    assert( 2 == chop(5, [1, 3, 5, 7]))
    assert( 3 == chop(7, [1, 3, 5, 7]))
    assert(-1 == chop(0, [1, 3, 5, 7]))
    assert(-1 == chop(2, [1, 3, 5, 7]))
    assert(-1 == chop(4, [1, 3, 5, 7]))
    assert(-1 == chop(6, [1, 3, 5, 7]))
    assert(-1 == chop(8, [1, 3, 5, 7]))
}

let test = [1, 2, 3, 4]
chop_iter(value: 3, list: test, l: 0, r: test.count-1)
// test.split().left.split()
// test.asRangeCovers(value: 6)
// let x = Array(test[0 ..< test.count/2])
//chop(3, test)
//test_chop()
