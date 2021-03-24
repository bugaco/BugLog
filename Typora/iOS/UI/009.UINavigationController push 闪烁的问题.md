`UINavigationController` push 闪烁的问题

```swift
override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
```

如果在父类中隐藏（或显示）导航栏，而在子类中，又显示（或隐藏）导航条，可能会造成子类导航条在push闪烁。

---

**解决方法：**

如果父类的`animated`参数为`true`，子类的改为`false`即可避免闪烁。