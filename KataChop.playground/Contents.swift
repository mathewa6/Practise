// A contorted variation of http://codekata.com/kata/kata02-karate-chop/

func chop(value: Int, list: [Int]) -> Int {
    
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
    var indices = Array(0 ..< n)
    
    var splits = list.split()!
    var splitx = indices.split()!
    
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

extension Array {
    func split() -> (left: [Element], right: [Element])? {
        let n = self.count
        if n == 1 {
            return nil
        }
        let half = n/2
        return (left: Array(self[0 ..< half]), right: Array(self[half ..< n]))
    }
    
    func asRangeCovers(value: Int) -> Bool {
        return value <= self.last as! Int && value >= self.first as! Int
    }
}

let test = [1, 3, 5, 7, 9, 11]
// test.split().left.split()
// test.asRangeCovers(value: 6)
// let x = Array(test[0 ..< test.count/2])
chop(value: 1, list: test)
