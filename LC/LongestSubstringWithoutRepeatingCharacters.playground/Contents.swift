
//Insert each character into a set and then check for new characters existing in the set.
class Solution {
    func lengthOfLongestSubstring(s: String) -> Int {
        var bowl: Set<Character> = []
        var count = s.isEmpty ? 0 : 1
        
        var returnMax = count
        
        for (i, char) in s.characters.enumerate() {
            if bowl.contains(char) {
                count = bowl.count > count ? bowl.count : count
                bowl.removeAll()
            }
            
            bowl.insert(char)
        }
        returnMax =  max(count, bowl.count)
        
        bowl = []
        count = s.isEmpty ? 0 : 1
        for (i, char) in s.characters.enumerate().reverse() {
            if bowl.contains(char) {
                count = bowl.count > count ? bowl.count : count
                bowl.removeAll()
            }
            
            bowl.insert(char)
        }
        
        return  max(count, returnMax)
    }
}

let sol = Solution()
let input = "asjrgapa"
sol.lengthOfLongestSubstring(input)