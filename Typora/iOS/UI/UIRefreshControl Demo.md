# UIRefreshControl Demo

```swift
lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl.init()
        self.tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshAllData), for: .valueChanged)
        return refreshControl
    }()
```

```swift
_ = refreshControl
tableView.bringSubviewToFront(refreshControl)
```

```swift
self.refreshControl.endRefreshing()
```

