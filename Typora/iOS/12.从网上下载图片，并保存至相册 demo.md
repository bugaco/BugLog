# 从网上下载图片，并保存至相册 demo

```swift
class ImageUtility: NSObject {
    func downloadUrlImageAndSaveToAlbum(_ imageUrl: String?) {
        guard let imageUrl = imageUrl else { return }
        if let url = URL(string: imageUrl) {
            if let data = try? Data(contentsOf: url) {
                guard let image = UIImage(data: data) else { return }
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(imageSaved(_:didFinishSavingWithError:contextInfo:)), nil)
            }
        }
    }
    
    //MARK: - Add image to Library
    @objc func imageSaved(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            makeToast("图片保存失败:\(error.localizedDescription)")
        } else {
            makeToast("图片保存成功")
        }
    }
}
```

