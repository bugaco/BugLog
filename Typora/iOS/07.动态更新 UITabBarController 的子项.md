# 动态更新 UITabBarController 的子项



之前用的`UIViewController`的 `addChild`方法，正常在`viewDidLoad`中使用的话，也没有问题

```swift
func addChild(_ childController: UIViewController)
```



但是，如果动态更新的话，上面的方法就无效了，要使用这个方法：

```swift
open func setViewControllers(_ viewControllers: [UIViewController]?, animated: Bool)
```

