import UserNotifications

final class AppNotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    // Show notifications even when app is in the foreground
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        [.banner, .sound]
    }

    // Handle notification taps — could deep-link in the future
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {
        // No-op for now; the app opens to the dashboard
    }
}
