# App 个别ViewController的横屏处理

## 背景

app锁定朝向，只支持竖屏很常见，像下边这样：

![image-20200620093516623](https://tva1.sinaimg.cn/large/007S8ZIlly1gfyi5yeglnj30zk0hltfw.jpg)

但也会遇到个别界面需要横屏展示的，比如视频播放界面，这个时候怎么办呢？

## 解决方法

### 1⃣️在AppDelegate中

添加朝向属性`orientationLock`，并实现`UIApplicationDelegate`协议中的方法：

```swift
class AppDelegate: UIResponder, UIApplicationDelegate {
    ...
    var orientationLock = UIInterfaceOrientationMask.portrait
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }
    ...
}
```

### 2⃣️添加横屏管理的工具类

```swift
extension AppDelegate {
    // MARK:  - 横屏管理
    struct AppUtility {
        static func lockOrientationToPortrait() {
            AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
        }
        
        static func lockOrientationToLandscapeRight() {
            AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.landscapeRight, andRotateTo: UIInterfaceOrientation.landscapeRight)
        }
        private static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                delegate.orientationLock = orientation
            }
        }
        
        private static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
            self.lockOrientation(orientation)
            UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        }
    }
}
```

## 使用

```swift
class ViewController4Landscape: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        AppDelegate.AppUtility.lockOrientationToLandscapeRight()
    }
    @IBAction func dismiss(_ sender: Any) {
        
        dismiss(animated: false) {
            AppDelegate.AppUtility.lockOrientationToPortrait()
        }
    }
}
```



## 效果

<video src="assets/Screen Recording 2020-06-20 at 9.52.45 AM.mov"></video>

