// http://blog.gainlo.co/index.php/2016/11/11/uber-interview-question-weighted-random-numbers/

struct WeightedInt {
    var value: String = "_"
    var weight: Int = 0
    
    init(v: String, w: Int) {
        self.value = v
        self.weight = w
    }
}

let array = [WeightedInt(v: "A",w: 1), WeightedInt(v: "B",w: 1), WeightedInt(v: "C",w: 2)]
let totalWeight = array.reduce(0) {
    $0 + $1.weight
}