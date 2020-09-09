String to SwiftyJSON



```
let encodedString : NSData = (string as NSString).data(using: String.Encoding.utf8.rawValue)! as NSData
                guard let json = try? JSON(data: encodedString as Data) else { return }
```

