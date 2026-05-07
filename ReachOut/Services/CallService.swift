import UIKit

enum CallService {
    /// Records the call on the Folk, reschedules notification, and opens the Phone app.
    /// Call is logged *before* dialing because iOS provides no callback for call completion.
    @MainActor
    static func call(_ folk: Folk, number: String) {
        folk.recordCall()
        NotificationService.scheduleNotification(for: folk)

        guard let url = PhoneNumberFormatter.telURL(for: number) else { return }

        #if targetEnvironment(simulator)
        // tel: URLs don't work on Simulator — handled by callers showing an alert
        #else
        UIApplication.shared.open(url)
        #endif
    }
}
