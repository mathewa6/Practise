//: # DP260Intermediate
//: ## https://redd.it/4cktc3
//: ---

//: Refer to http://math.stackexchange.com/questions/1527319/number-of-squares-crossed-by-a-diagonal

func gcd(a: Int, _ b: Int) -> Int {
    if a % b == 0 {
        return b
    } else {
        return gcd(b, a % b)
    }
}

func numberOfIntersectedSquares(x: Int, y: Int) -> Int {
    return x + y - gcd(x, y)
}

numberOfIntersectedSquares(21, y: 2)