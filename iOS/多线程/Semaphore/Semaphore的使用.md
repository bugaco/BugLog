# Semaphore的使用

## 1.简单的demo，模拟下载歌曲，最多同时下载3首

```swift
let queue = DispatchQueue(label: "com.gcd.myQueue", attributes: .concurrent)
let semaphore = DispatchSemaphore(value: 3)
for i in 1 ... 15 {
    queue.async {
        let songNumber = i + 1
        semaphore.wait()
        print("Downloading song", songNumber)
        sleep(UInt32.random(in: 3...10))
        print("Downloaded song", songNumber)
        semaphore.signal()
    }
}

```

## 2.实现依次弹出三个Alert Controller

```swift
class ViewController: UIViewController {
    
    let semaphore = DispatchSemaphore.init(value: 1)
    let queue = DispatchQueue(label: "com.bugaco.queue", attributes: .concurrent)
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        showAlerts()
    }
    
    private func showAlerts() {
        for i in 1...3 {
            queue.async {
                self.semaphore.wait()
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Alert - \(i)", message: nil, preferredStyle: .alert)
                    alert.addAction(.init(title: "确定", style: .default, handler: { (_) in
                        self.semaphore.signal()
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
}

```

> 效果

<video src="Assets/Screen Recording 2020-11-04 at 5.50.05 PM.mov"></video>

