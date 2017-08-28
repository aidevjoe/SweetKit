import Foundation
import AVKit

class LocalNotificationHelper: NSObject {
    
    let LOCAL_NOTIFICATION_CATEGORY : String = "LocalNotificationCategory"
    
    // MARK: - Shared Instance
    
    class var shared: LocalNotificationHelper {
        struct Singleton {
            static var sharedInstance = LocalNotificationHelper()
        }
        return Singleton.sharedInstance
    }
    
    // MARK: - Schedule Notification
    
    func scheduleNotificationWithKey(key: String, title: String, message: String, seconds: Double, userInfo: [String: Any]?) {
        let date = Date(timeIntervalSinceNow: TimeInterval(seconds))
        let notification = notificationWithTitle(key: key, title: title, message: message, date: date, userInfo: userInfo, soundName: nil, hasAction: true)
        notification.category = LOCAL_NOTIFICATION_CATEGORY
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    func scheduleNotificationWithKey(key: String, title: String, message: String, date: Date, userInfo: [String: Any]?){
        let notification = notificationWithTitle(key: key, title: title, message: message, date: date, userInfo: ["key": key], soundName: nil, hasAction: true)
        notification.category = LOCAL_NOTIFICATION_CATEGORY
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    func scheduleNotificationWithKey(key: String, title: String, message: String, seconds: Double, soundName: String, userInfo: [NSObject: AnyObject]?){
        let date = Date(timeIntervalSinceNow: TimeInterval(seconds))
        let notification = notificationWithTitle(key: key, title: title, message: message, date: date, userInfo: ["key": key], soundName: soundName, hasAction: true)
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    func scheduleNotificationWithKey(key: String, title: String, message: String, date: Date, soundName: String, userInfo: [String: Any]?){
        let notification = notificationWithTitle(key: key, title: title, message: message, date: date, userInfo: ["key": key], soundName: soundName, hasAction: true)
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    // MARK: - Present Notification
    
    func presentNotificationWithKey(key: String, title: String, message: String, soundName: String, userInfo: [String: Any]?) {
        let notification = notificationWithTitle(key: key, title: title, message: message, date: nil, userInfo: ["key": key], soundName: nil, hasAction: true)
        UIApplication.shared.presentLocalNotificationNow(notification)
    }
    
    /// 添加一个本地通知
    ///
    /// - Parameters:
    ///   - key: key
    ///   - title: 通知上显示的主题内容
    ///   - message: 待机界面的滑动动作提示
    ///   - date: 通知的触发时间，例如即刻起15分钟后
    ///   - userInfo: 通知上绑定的其他信息，为键值对
    ///   - soundName: 通知的声音
    ///   - hasAction: 启动滑块
    /// - Returns: UILocalNotification
    func notificationWithTitle(key : String, title: String, message: String, date: Date?, userInfo: [String: Any]?, soundName: String?, hasAction: Bool) -> UILocalNotification {
        
        var dct = userInfo
        dct?["key"] = String(stringLiteral: key) as Any?
        
        let notification = UILocalNotification()
        notification.alertAction = title
        notification.alertBody = message
        notification.userInfo = dct
        notification.soundName = soundName ?? UILocalNotificationDefaultSoundName
        notification.fireDate = date as Date?
        notification.hasAction = hasAction
        return notification
    }
    
    func getNotificationWithKey(key : String) -> UILocalNotification {
        
        var notif : UILocalNotification?
        
        for notification in UIApplication.shared.scheduledLocalNotifications! where notification.userInfo!["key"] as! String == key{
            notif = notification
            break
        }
        
        return notif!
    }
    
    func cancelNotification(key : String){
        
        for notification in UIApplication.shared.scheduledLocalNotifications! where notification.userInfo!["key"] as! String == key{
            UIApplication.shared.cancelLocalNotification(notification)
            break
        }
    }
    
    func getAllNotifications() -> [UILocalNotification]? {
        return UIApplication.shared.scheduledLocalNotifications
    }
    
    func cancelAllNotifications() {
        UIApplication.shared.cancelAllLocalNotifications()
    }
    
    func registerUserNotificationWithActionButtons(actions : [UIUserNotificationAction]){
        
        let category = UIMutableUserNotificationCategory()
        category.identifier = LOCAL_NOTIFICATION_CATEGORY
        
        category.setActions(actions, for: UIUserNotificationActionContext.default)
        
        let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: NSSet(object: category) as? Set<UIUserNotificationCategory>)
        UIApplication.shared.registerUserNotificationSettings(settings)
    }
    
    func registerUserNotification(){
        
        let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)
    }
    
    func createUserNotificationActionButton(identifier : String, title : String) -> UIUserNotificationAction{
        
        let actionButton = UIMutableUserNotificationAction()
        actionButton.identifier = identifier
        actionButton.title = title
        actionButton.activationMode = UIUserNotificationActivationMode.background
        actionButton.isAuthenticationRequired = true
        actionButton.isDestructive = false
        
        return actionButton
    }
    
}
