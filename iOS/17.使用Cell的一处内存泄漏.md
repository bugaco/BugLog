

Controller中有一处方法：

```swift
private func requestCheckInInfo() {
        ...
}
```

Cell中有一个Closure:

```swift
var refreshDataClosure: Closure?
```

如果在Controller中这样简写：

```swift
cell.refreshDataClosure = requestCheckInInfo
```

Controller就无法释放了。

应该这样写，这里需要将`self`弱化：

```swift
cell.refreshDataClosure = {[weak self] in
		self?.requestCheckInInfo()
}
```

