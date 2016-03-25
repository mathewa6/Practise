import Foundation

let nums = [1, 7, 11, 2, 15], target = 9

class Solution {

    func twoSum(nums: [Int], _ target: Int) -> [Int] {
        var pot = Set<Int>()
        var solution: [Int] = [0, 0]
        for (idx, element) in nums.enumerate() {
            if pot.contains(element) {
                solution = [nums.indexOf(target-element)!, idx]
            } else {
                pot.insert(target - element)
            }
        }
        return solution
    }
    
    //Fastest
    func twoSumAlt(nums: [Int], _ target: Int) -> [Int] {
        var pot = [Int : Int]()
        var solution: [Int] = [0, 0]
        for (idx, element) in nums.enumerate() {
            if pot[element] != nil {
                solution = [pot[element]!, idx]
                break
            } else {
                pot[target - element] = idx
            }
        }
        return solution
    }
    
    func twoSumRev(nums: [Int], _ target: Int) -> [Int] {
        var pot = [Int : Int]()
        var solution: [Int] = [0, 0]
        for idx in 0..<nums.count/2 + 1{
            let element = nums[idx]
            let jdx = nums.count-idx-1
            let reversedElement = nums[jdx]
            if pot[element] != nil {
                solution = [idx, pot[element]!]
                break
            } else {
                pot[target - element] = idx
            }
            if pot[reversedElement] != nil {
                solution = [jdx, pot[reversedElement]!]
                break
            } else {
                pot[target - reversedElement] = jdx
            }
        }
        return solution
    }

    func twoSumDisc(nums: [Int], _ target: Int) -> [Int] {
        var solution: [Int] = []
        let sortedNums = nums.sort()
        let len = nums.count
        var min = 0, max = len - 1
        while true {
            let count = sortedNums[min] + sortedNums[max]
            if count > target {
                max -= 1
            } else if count < target {
                min += 1
            } else {
                break
            }
        }
        for (idx, element) in nums.enumerate() {
            if sortedNums[min] == element || sortedNums[max] == element {
                solution.append(idx)
            }
        }
        return solution
    }
}

let sol = Solution()
sol.twoSumAlt(nums, target)

