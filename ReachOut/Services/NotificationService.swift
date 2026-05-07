import UserNotifications

enum NotificationService {
    /// Request notification permission. Call once at app startup.
    static func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }

    /// Schedules (or reschedules) a notification for when a Folk's call is due.
    /// Uses the Folk's UUID as the notification identifier so each Folk gets exactly one pending notification.
    static func scheduleNotification(for folk: Folk) {
        let center = UNUserNotificationCenter.current()
        let identifier = folk.id.uuidString

        // Remove any existing notification for this folk
        center.removePendingNotificationRequests(withIdentifiers: [identifier])

        // Calculate time interval until the next call is due
        let intervalSeconds = TimeInterval(folk.targetCallFrequencyInHours) * 3600

        let triggerInterval: TimeInterval
        if let lastCallDate = folk.lastCallDate {
            let secondsSinceLastCall = Date().timeIntervalSince(lastCallDate)
            let remaining = intervalSeconds - secondsSinceLastCall
            triggerInterval = max(remaining, 60) // at least 60s in the future
        } else {
            // Never called — notify after the full frequency period
            triggerInterval = intervalSeconds
        }

        let content = UNMutableNotificationContent()
        content.title = "Time to call \(folk.userAssignedName)"
        content.body = "You wanted to stay in touch \(frequencyDescription(hours: folk.targetCallFrequencyInHours)). Give them a ring!"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: triggerInterval, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        center.add(request) { _ in }
    }

    /// Cancels any pending notification for a Folk (e.g. when deleting).
    static func cancelNotification(for folk: Folk) {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [folk.id.uuidString])
    }

    private static func frequencyDescription(hours: Int) -> String {
        switch hours {
        case 24: "daily"
        case 168: "weekly"
        case 336: "every two weeks"
        case 720: "monthly"
        case 2160: "quarterly"
        default: "every \(hours) hours"
        }
    }
}
