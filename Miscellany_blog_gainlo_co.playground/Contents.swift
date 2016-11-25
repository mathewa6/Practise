
/**
 This section is irrelevant and was simply experimenting to see how raw pointers work in swift.
 */
/// http://stackoverflow.com/questions/26395961/swift-array-element-address
struct testStruc {
    var _val = [Int](repeating: 0, count: 1000);
    subscript(idx:Int) -> Int {
        get {
            print("get: [\(idx)] -> val(\(_val[idx]))")
            return _val[idx]
        }
        set(val) {
            print("set: [\(idx)] old(\(_val[idx])) -> new(\(val))")
            _val[idx] = val
        }
    }
}

func testFunc( ptr:inout UnsafeMutablePointer<Int>, val:Int) {
    print("mutating: ptr(\(ptr)) <- \(val)")
    ptr.pointee = val
}

/**
 twoSum(): Finds whether any 2 elements exactly add up to 'sum'.
 threeSum(): Finds whether 3 elements add to 'sum' by calling twoSum().
 */
/// http://blog.gainlo.co/index.php/2016/07/19/3sum/
func twoSum(forSum sum: Int, withArray array: [Int]) -> Bool {
    
    // Is array sorted? For now, assume it is
    
    var a = 0 // Leading index
    var b = array.count - 1 // Trailing index
    var s = array[a] + array[b] // Sum of elements at the leading and trailing indices
    var exists = false
    
    // As long as the indices aren't meeting, iterate...
    while a != b {
        
        // If the sum of elements at indices a & b equals sum, then the 2Sum exists.
        if s == sum  {
            exists = true
            break
        } else if s > sum {
            b -= 1
        } else {
            a += 1
        }
        // Otherwise, pull the trailing back if a + b > sum
        // Or push the leading forward if a + b < sum
        
        s = array[a] + array[b]
    }
    
    return exists
}

func threeSum(forSum sum: Int, withArray array: [Int]) -> Bool {
    var sumExists = false
    
    for x in array {
        let isTwoTrue = twoSum(forSum: sum-x, withArray: array)
        if isTwoTrue {
            sumExists = true
        }
    }
    
    return sumExists
}

let testArray = [1, 5, 7]
threeSum(forSum: 6, withArray: testArray)
