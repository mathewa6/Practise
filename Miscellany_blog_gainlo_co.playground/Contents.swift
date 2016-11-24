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

/// http://blog.gainlo.co/index.php/2016/07/19/3sum/
func twoSum(forSum sum: Int, withArray array: [Int]) -> Bool {
    
    // Is array sorted? For now, assume it is
    var a = 0
    var b = array.count - 1
    var s = array[a] + array[b]
    var isTrue = false
    
    while a != b {
        
        if s == sum  {
            isTrue = true
            break
        } else if s > sum {
            b -= 1
        } else {
            a += 1
        }
        
        s = array[a] + array[b]
    }
    
    return isTrue
}

func threeSum(forSum sum: Int, withArray array: [Int]) -> Bool {
    var isTrue = false
    
    for x in array {
        let isTwoTrue = twoSum(forSum: sum-x, withArray: array)
        if isTwoTrue {
            isTrue = true
        }
    }
    
    return isTrue
}

let testArray = [1, 5, 7]
threeSum(forSum: 6, withArray: testArray)
