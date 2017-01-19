class Kalman: CustomStringConvertible {
    var q = 0.0
    var r = 0.0
    var x = 0.0
    var p = 0.0
    var k = 0.0
    
    init(q: Double, r: Double, p: Double, measurement: Double) {
        self.q = q
        self.r = r
        self.p = p
        
        self.x = measurement
    }
    
    convenience init() {
        self.init(q: 0.0, r: 0.0, p: 0.0, measurement: 0.0)
    }
    
    func update(x measurement: Double) {
        self.p += self.q
        
        self.k = self.p/(self.p + self.r)
        self.x += self.k * (measurement - self.x)
        self.p *= (1 - self.k)
    }
    
    var description: String {
        return "q:\(q), r:\(r), x:\(x), p:, k:\(k)"
    }
}

let compKal = Kalman(q: 0.5,r: 4,p: 25, measurement: 180)

let inputs = [180, 200, 184, 187, 191]
for x in inputs {
    compKal.update(x: Double(x))
    compKal.x
}