
//Insert each character into a set and then check for new characters existing in the set.
// TODO: - Try http://www.geeksforgeeks.org/length-of-the-longest-substring-without-repeating-characters/ for alt solution.
class Solution {
    func lengthOfLongestSubstring(s: String) -> Int {
        var bowl = [Character : Int]()
        var count = 0, left = 0


        for (i, char) in s.characters.enumerate() {
            
            if let key = bowl[char] {
                count = max(count, i - left)
                left = max(left, key + 1)
            }
            
            bowl[char] = i
        }
        
        return max(count, s.characters.count - left)
    }
}

let sol = Solution()
let input = "dvdf" //jxgqtuorkyqyvnpmutwxhqufgazxfzbqzigseulrubpqree
sol.lengthOfLongestSubstring(input)
