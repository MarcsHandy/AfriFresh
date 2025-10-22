import Foundation
import UserNotifications
import SwiftUI

/// NotificationService handles push notifications (local & remote)
final class NotificationService: NSObject, ObservableObject {
    
    static let shared = NotificationService()
    
    private override init() {} // Must override because we inherit NSObject
    
    // MARK: - Request Permission
    func requestPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ Notification permission error: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                print("✅ Notification permission granted: \(granted)")
                completion(granted)
            }
        }
    }
    
    // MARK: - Schedule Local Notification
    func scheduleLocalNotification(title: String,
                                   body: String,
                                   inSeconds seconds: TimeInterval,
                                   identifier: String = UUID().uuidString) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Failed to schedule local notification: \(error.localizedDescription)")
            } else {
                print("✅ Local notification scheduled: \(title) - in \(seconds) sec")
            }
        }
    }
    
    // MARK: - Cancel Notifications
    func cancelNotification(identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        print("🗑️ Cancelled notification: \(identifier)")
    }
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("🗑️ Cancelled all notifications")
    }
    
    // MARK: - Setup Delegate
    func setDelegate() {
        UNUserNotificationCenter.current().delegate = self
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension NotificationService: UNUserNotificationCenterDelegate {
    
    // Called when a notification is delivered while app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler:
                                @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
    
    // Called when user taps on a notification
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        print("📣 User tapped notification: \(response.notification.request.identifier)")
        completionHandler()
    }
}
