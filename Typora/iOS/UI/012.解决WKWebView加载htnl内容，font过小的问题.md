# 解决WKWebView加载htnl内容，font过小的问题

```swift
        let headerString = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>"
        let finalContent = headerString + content
        webView.loadHTMLString(finalContent , baseURL: nil)
```

