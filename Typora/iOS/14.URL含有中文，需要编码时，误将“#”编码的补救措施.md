# URL含有中文，需要编码时，误将“#”编码的补救措施

> 使用WebView打开带中文的url时，需要将url进行编码，但也会将原来的#号进行进行编码，这个是不需要的，#号编码后会出现异常。



> 此时有个比较笨拙的补救方法，单独将#号解码回去

```swift
    let provinceName = "河南省"
    let cityName = "洛阳市"
    let token = "invalidToken"
    var urlString: String {
        let originUrl = "http://youmiyouyu.mrack.top/index.html#/index?longitude=113&latitude=34&provinceName=\(provinceName)&cityName=\(cityName)&token=\(token)"
        let rst = originUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        /* 在将中文编码时，会将#号也编码，这样就不能识别为正常的url了，手动转回来了*/
        let rst2 = rst.replacingOccurrences(of: "%23", with: "#")
        return rst2
    }	
```

或许有其他更科学的方法，在编码时，忽略“#”，我还没找到，先挖个坑