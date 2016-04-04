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

public class LLNode<T>: CustomStringConvertible {
    var value: T
    var next: LLNode?
    var previous: LLNode?
    
    public init(value: T) {
        self.value = value
    }
    
    public var description: String {
        if self.next != nil {
            return "\(self.value) > \(self.next!.value) "
        }
        
        return "\(self.value)"
    }
}

class Solution {
    func addTwoNumbers(l1: ListNode?, _ l2: ListNode?) -> ListNode? {
        var x = l1
        var y = l2
        
        var sum: ListNode?
        var head: ListNode?
        
        func checkAddition(x: Int, y: Int, carry: Int) -> (Int, Int) {
            let addition = x + y + carry
            let value = addition > 9 ? addition % 10 : addition
            let returnCarry = addition > 9 ? 1 : 0
            
            return (value, returnCarry)
        }
        
        var carry = 0
        while x != nil && y != nil {
            let addition = checkAddition(x!.val, y: y!.val, carry: carry)
            carry = addition.1
            
            if  sum != nil {
                sum?.next = ListNode(addition.0)
                sum = sum?.next
            } else {
                sum = ListNode(addition.0)
                head = sum
            }
            
            x = x?.next
            y = y?.next
        }
        
        if carry > 0 {
//            If there is a carry here it has the potential to chain down the list.
            if x == nil && y == nil {
                sum?.next = ListNode(carry)
                carry = 0
            } else if x != nil {
                sum?.next = x!
            } else if y != nil {
                sum?.next = y!
            }
            var node = sum?.next
            while node != nil && carry  > 0 {
                let addition = checkAddition(node!.val, y: carry, carry: 0)
                node?.val = addition.0
                carry = addition.1
                if carry > 0 && node?.next == nil {
                    node?.next = ListNode(carry)
                    carry = 0
                }
                node = node?.next
            }
            
            
        } else {
            if x != nil {
                sum?.next = x!
            } else if y != nil {
                sum?.next = y!
            }
        }
        
        
        
        return head
    }
    
    func addTwoNumbersAlt(l1: ListNode?, _ l2: ListNode?) -> ListNode? {
        let head = ListNode(0)
        
        var node = head
        var flag = 0
        var a = l1, b = l2
        
        while a != nil || b != nil {
            node.val += (a?.val ?? 0) + (b?.val ?? 0)
            
            a = a?.next
            b = b?.next
            
            flag = node.val / 10
            node.val %= 10
            
            if a != nil || b != nil || flag > 0 {
                node.next = ListNode(flag)
                node = node.next!
            }
        }
        
        return head
    }
    
    func addTwoNumbersSplit(l1: ListNode?, _ l2: ListNode?) -> ListNode? {
        var carry = 0
        var a = l1, b = l2
        let head = ListNode(0)
        
        var node = head
        while a != nil || b != nil || carry > 0 {
            if a != nil {
                carry += a?.val ?? 0
                a = a?.next
            }
            if b != nil {
                carry += b?.val ?? 0
                b = b?.next
            }
            node.next = ListNode(carry % 10)
            node = node.next!
            carry /= 10
        }
        return head.next
    }
    
    func addTwoNumbersShort(l1: ListNode?, _ l2: ListNode?) -> ListNode? {
        var sum = 0, carry = 0, remainder = 0
        var a = l1, b = l2
        let head = ListNode(0)
        
        var node = head
        while a != nil || b != nil || carry != 0 {
            sum = (a?.val ?? 0) + (b?.val ?? 0) + carry
            carry = sum / 10
            remainder = sum % 10
            
            node.next = ListNode(remainder)
            node = node.next!
            a = a?.next
            b = b?.next
        }
        return head.next
    }
}

//: ### Put the following in a new linkedList Class.
let a = ListNode(5)
a.next =  ListNode(9)
a.next?.next = ListNode(3)
a.next?.next?.next = ListNode(8)


let b = ListNode(5)
b.next = ListNode(9)
b.next?.next = ListNode(9)

let sol = Solution()
//var ans = sol.addTwoNumbers(a, b)
//var ans = sol.addTwoNumbersAlt(a, b)
//var ans = sol.addTwoNumbersSplit(a, b)
var ans = sol.addTwoNumbersShort(a, b)



var stringVal = ""
while ans != nil {
    stringVal += "\(ans!.val)"
    ans = ans?.next
}

stringVal
