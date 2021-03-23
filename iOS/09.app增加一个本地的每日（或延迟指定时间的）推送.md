# app增加一个本地的每日（或延迟指定时间的）推送

## 1⃣️请求权限

```swift
import Foundation
import UserNotifications

struct  NotificationRepository {
    static let share = NotificationRepository()

    typealias NotiAuthorizationCompletion = (Bool, Error?) -> Void
    static func requestAuthorization(completionHandler: @escaping NotiAuthorizationCompletion) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: completionHandler)
    }
}
```

## 2⃣️如果获取到推送权限，添加提醒

```swift
            NotificationRepository.requestAuthorization { (success, error) in
                var msg: String?
                if success {
                    msg = "设置成功"
                    self.addNoti()
                } else if let errorMsg = error?.localizedDescription {
                    
                    msg = errorMsg
                    print(msg!)
                }
                if let msg = msg {
                    execute {
                        UIApplication.shared.keyWindow?.makeToast(msg)
                    }
                }
            }
```

添加提醒的方法：

```swift
extension SettingTableViewCell {
    private func addNoti() {
        let content = UNMutableNotificationContent()
        content.title = "签到提醒"
        content.subtitle = "每日签到获取更多金币"
        content.sound = UNNotificationSound.default

        /*
        // show this notification five seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
         */
        
        // 每天9点重复
        var date = DateComponents()
        date.hour = 9
        date.minute = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }
}
```

