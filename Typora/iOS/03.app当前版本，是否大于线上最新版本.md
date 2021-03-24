```swift
import Foundation

func checkIsInReview(onlineVersion: String?, currentVersion: String?) -> Bool {
    
    guard let onlineVersion = onlineVersion, let currentVersion = currentVersion else {
        return false
    }
    
    let onlineVersionArray = onlineVersion.components(separatedBy: ".")
    let currentVersionArray = currentVersion.components(separatedBy: ".")
    
    /** 对小版本号，从左往右对比 */
    for (index, curVersionNumStr) in currentVersionArray.enumerated() {
        
        
        /** 如果线上某一位为空，则用0来代替。比如线上版本号为"2.5"，当前为"2.5.1"，则把线上的按"2.5.0"来算 */
        var onlineVersionNumStr = "0"
        if index <= onlineVersionArray.count - 1 {
            onlineVersionNumStr = onlineVersionArray[index]
        }
        
        // 如果当前的各版本号数字，比线上对应的版本号大，则说明正在审核，返回true
        let curVersionNum = Int(curVersionNumStr) ?? 0
        let onlineVersionNum = Int(onlineVersionNumStr) ?? 0
        print("curVersionNum: \(curVersionNum), onlineVersionNum: \(onlineVersionNum)")
        if curVersionNum > onlineVersionNum {
            return true
        }
    }
    
    return false
}

let onlineVersion = "2.5.1"
let curVersion = "2.5.2"

checkIsInReview(onlineVersion: onlineVersion, currentVersion: curVersion) // true
```

