/**
 * Definition for singly-linked list.
 * public class ListNode {
 *     public var val: Int
 *     public var next: ListNode?
 *     public init(_ val: Int) {
 *         self.val = val
 *         self.next = nil
 *     }
 * }
 */

public class ListNode: CustomStringConvertible {
    public var val: Int
    public var next: ListNode?
    
    public init(_ val: Int) {
        self.val = val
        self.next = nil
    }
    
    public var description: String {
        if self.next != nil {
            return "\(self.val) > \(self.next!.val) "
        }
        
        return "\(self.val)"
    }
}

class Solution {
    func addTwoNumbers(l1: ListNode?, _ l2: ListNode?) -> ListNode? {
        var x = l1
        var y = l2
        
        var sum: ListNode?
        var head: ListNode?
        
        var carry = 0
        while x != nil && y != nil {
            let addition = x!.val + y!.val + carry
            let value = addition > 9 ? addition % 10 : addition
            carry = addition > 9 ? 1 : 0
            
            if  sum != nil {
                sum?.next = ListNode(value)
                sum = sum?.next
            } else {
                sum = ListNode(value)
                head = sum
            }
            
            x = x?.next
            y = y?.next
        }
        
        if carry > 0 {
            sum?.next = ListNode(carry)
        }
        return head
    }
}

//: ### Put the following in a new linkedList Class.
let a = ListNode(1)
a.next =  ListNode(2)
a.next?.next = ListNode(3)

let b = ListNode(4)
b.next = ListNode(5)
b.next?.next = ListNode(6)

let sol = Solution()
var ans = sol.addTwoNumbers(a, b)

var stringVal = ""
while ans != nil {
    stringVal += "\(ans!.val)"
    ans = ans?.next
}

stringVal
