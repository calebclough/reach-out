import Foundation
import SwiftData

@Model
final class Folk {
    var id: UUID
    var userAssignedName: String
    var contactNumbers: [String]
    var targetCallFrequencyInHours: Int
    var streak: Int
    var lastCallDate: Date?
    var dateAdded: Date
    @Attribute(.externalStorage) var imageData: Data?

    init(
        userAssignedName: String,
        contactNumbers: [String] = [],
        targetCallFrequencyInHours: Int = 168, // weekly default
        lastCallDate: Date? = nil,
        imageData: Data? = nil
    ) {
        self.id = UUID()
        self.userAssignedName = userAssignedName
        self.contactNumbers = contactNumbers
        self.targetCallFrequencyInHours = targetCallFrequencyInHours
        self.streak = 0
        self.lastCallDate = lastCallDate
        self.dateAdded = Date()
        self.imageData = imageData
    }

    var nextCallDueDate: Date? {
        guard let lastCallDate else { return nil }
        return lastCallDate.addingTimeInterval(TimeInterval(targetCallFrequencyInHours) * 3600)
    }

    var hoursUntilDue: Double? {
        guard let nextCallDueDate else { return nil }
        return nextCallDueDate.timeIntervalSince(Date()) / 3600
    }

    var status: FolkStatus {
        guard let lastCallDate else { return .overdue }

        let totalSeconds = TimeInterval(targetCallFrequencyInHours) * 3600
        let elapsed = Date().timeIntervalSince(lastCallDate)

        if elapsed >= totalSeconds {
            return .overdue
        }

        // Yellow threshold: min(24 hours, targetFrequency / 4)
        let yellowThresholdSeconds = min(24.0 * 3600, totalSeconds / 4.0)
        let remaining = totalSeconds - elapsed

        if remaining <= yellowThresholdSeconds {
            return .approaching
        }

        return .onTrack
    }

    func recordCall() {
        let wasOverdue = status == .overdue
        lastCallDate = Date()

        if wasOverdue || streak == 0 {
            streak = 1
        } else {
            streak += 1
        }
    }
}
