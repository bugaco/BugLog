百度统计中显示，有很多以下crash记录：

```swift
*** Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'Completion handler passed to -[通信营业中心.WebViewController webView:runJavaScriptAlertPanelWithMessage:initiatedByFrame:completionHandler:] was not called'
```

查了资料，decisionHandler 必须 allow 或 cancel

```swift
func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

}
```

