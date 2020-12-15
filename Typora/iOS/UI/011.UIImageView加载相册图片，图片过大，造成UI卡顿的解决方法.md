# UIImageView加载相册图片，图片过大，造成UI卡顿的解决方法

> 思路：在`background thread`中将图片压缩，然后在主线程中显示

代码：

```swift
        if let image = image {
            deleteButton.isHidden = false
            DispatchQueue.global(qos: .background).async {
                if let compressionData = image.jpegData(compressionQuality: 0.01) {
                    DispatchQueue.main.async {
                        self.imageView.image = UIImage(data: compressionData)
                    }
                }
            }
        }
```

