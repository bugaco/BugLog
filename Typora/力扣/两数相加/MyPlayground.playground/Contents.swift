
// Definition for singly-linked list.
public class ListNode {
    public var val: Int
    public var next: ListNode?
    public init(_ val: Int) {
        self.val = val
        self.next = nil
    }
}

class Solution {
    func addTwoNumbers(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
        
        var curL1 = l1
        var curL2 = l2
        var firstNode: ListNode?
        var currentNode: ListNode?
        var carry = 0 // 用于低位向高位进1
        
        while true {
            let v1 = curL1?.val ?? 0
            let v2 = curL2?.val ?? 0
            var currentValue: Int = v1 + v2 + carry
            if currentValue >= 10 {
                currentValue -= 10
                carry = 1
            } else {
                carry = 0
            }
  
            // 第一次
            if firstNode == nil {
                firstNode = ListNode(currentValue)
                currentNode = firstNode
            } else {
                let newNode = ListNode(currentValue)
                currentNode?.next = newNode
                currentNode = newNode
            }
            
            curL1 = curL1?.next
            curL2 = curL2?.next
            // 当l1和l2都没有下一个节点，而且不需要进位的时候，结束
            // 退出条件
            if curL1 == nil && curL2 == nil && carry == 0 {
                break
            }
        }
        return firstNode
    }
}


let n1 = ListNode(5)
let n4 = ListNode(5)
let rst1 = Solution().addTwoNumbers(n1, n4)
rst1?.val
let rst2 = rst1?.next
rst2?.val
let rst3 = rst2?.next
rst3?.val
print("\n\n result: \n")
print("rst1: \(rst1?.val ?? -1)  rst1: \(rst2?.val ?? -1)")
