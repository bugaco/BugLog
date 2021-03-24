```swift
            let htmlData = NSString(string: ruleHtml).data(using: String.Encoding.unicode.rawValue)
            let options = [NSAttributedString.DocumentReadingOptionKey.documentType:
                            NSAttributedString.DocumentType.html]
            if let attributedString = try? NSMutableAttributedString(data: htmlData ?? Data(),
                                                                     options: options,
                                                                     documentAttributes: nil) {
                label.attributedText = attributedString
            }
```

如果html的样式比较素，要修改字体、颜色的话，可以这样：

```swift
let range = NSRange.init(location: 0, length: attributedString.length)
                let option = [NSAttributedString.Key.foregroundColor: UIColor.init(hex: "#503214")!,
                              NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .medium)]
                attributedString.addAttributes(option, range: range)
```

