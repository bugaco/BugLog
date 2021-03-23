



### 1⃣️**第三方的生成工具**

设备重置后，会变化



### 2⃣️UIDevice.current.identifierForVendor?.uuidString

app重新安装就会变化



### 3⃣️ASIdentifierManager.shared().advertisingIdentifier

**Limit Ad Tracking**打开后，会变成 **00000000-0000-0000-0000-000000000000**

即使**Limit Ad Tracking**再关闭，也会重新生成