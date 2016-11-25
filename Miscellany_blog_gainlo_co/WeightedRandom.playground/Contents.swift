// http://blog.gainlo.co/index.php/2016/11/11/uber-interview-question-weighted-random-numbers/
import Foundation

struct WeightedInt: CustomStringConvertible {
    var value: String = "_"
    var weight: Int = 0
    
    init() {
        
    }
    
    init(v: String, w: Int) {
        self.value = v
        self.weight = w
    }
    
    var description: String {
        return "\(value) : \(weight)"
    }
}

func randw(fromArray array: [WeightedInt]) -> WeightedInt {
    var chosenw: WeightedInt = array.first ?? WeightedInt()
    
    let totalWeight = array.reduce(0) {
        $0 + $1.weight
    }
    
    let rand = 1 // Int(arc4random_uniform(UInt32(totalWeight)))
    
    var s = array.first!.weight
    for i in 1..<array.count {
        if s >= rand {
            chosenw = array[i-1]
            break
        }
        s += array[i].weight
    }
    
    return chosenw
}

let array = [WeightedInt(v: "A",w: 1), WeightedInt(v: "B",w: 1), WeightedInt(v: "C",w: 2)]
randw(fromArray: array)