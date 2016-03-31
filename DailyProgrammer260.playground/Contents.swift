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

