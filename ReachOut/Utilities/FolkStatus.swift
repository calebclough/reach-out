import SwiftUI

enum FolkStatus: String, Codable {
    case onTrack
    case approaching
    case overdue

    var color: Color {
        switch self {
        case .onTrack: Color(red: 0.48, green: 0.62, blue: 0.49)      // sage green
        case .approaching: Color(red: 0.77, green: 0.57, blue: 0.23)  // warm amber
        case .overdue: Color(red: 0.76, green: 0.42, blue: 0.35)      // terracotta
        }
    }

    var iconName: String {
        switch self {
        case .onTrack: "checkmark.circle.fill"
        case .approaching: "exclamationmark.triangle.fill"
        case .overdue: "phone.down.fill"
        }
    }

    var label: String {
        switch self {
        case .onTrack: "On Track"
        case .approaching: "Call Soon"
        case .overdue: "Overdue"
        }
    }
}
