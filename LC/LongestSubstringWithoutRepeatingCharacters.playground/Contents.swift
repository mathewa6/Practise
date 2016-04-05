
//Insert each character into a set and then check for new characters existing in the set.
class Solution {
    func lengthOfLongestSubstring(s: String) -> Int {
        var maxCount = s.isEmpty ? 0 : 1

        for (i, _) in s.characters.enumerate() {
            var bowl: Set<Character> = []
            var count = s.isEmpty ? 0 : 1
            
            for j in i..<s.characters.count {
                let character = s[s.startIndex.advancedBy(j)]
                if bowl.contains(character) {
                    count = bowl.count > count ? bowl.count : count
                    bowl.removeAll()
                }
                
                if j == s.characters.count - 1 {
                    bowl.insert(character)
                    count = bowl.count > count ? bowl.count : count
                }
                
                bowl.insert(character)
            }
            
            maxCount = max(count, maxCount)
        }
        
        return maxCount

    }
}

let sol = Solution()
let input = "jxgqtuorkyqyvnpmutwxhqufgazxfzbqzigseulrubpqree"
sol.lengthOfLongestSubstring(input)