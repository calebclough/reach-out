import SwiftUI

struct FolkTileView: View {
    let folk: Folk

    var body: some View {
        HStack(spacing: 14) {
            folkAvatar

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(folk.userAssignedName)
                        .font(.headline)
                        .lineLimit(1)
                    Spacer()
                    StreakBadgeView(streak: folk.streak)
                }

                HStack {
                    Image(systemName: folk.status.iconName)
                    Text(folk.status.label)
                        .font(.subheadline)
                }
                .foregroundStyle(statusForeground)

                if let hoursUntilDue = folk.hoursUntilDue {
                    Text(dueText(hours: hoursUntilDue))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else {
                    Text("Never called")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(tileBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var folkAvatar: some View {
        Group {
            if let imageData = folk.imageData,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                Text(folk.userAssignedName.prefix(1).uppercased())
                    .font(.title2.weight(.medium))
                    .foregroundStyle(statusForeground)
            }
        }
        .frame(width: 48, height: 48)
        .background(folk.status.color.opacity(0.2))
        .clipShape(Circle())
    }

    private var tileBackground: some ShapeStyle {
        folk.status.color.opacity(0.15)
    }

    private var statusForeground: Color {
        switch folk.status {
        case .onTrack: Color(red: 0.38, green: 0.53, blue: 0.39)      // deep sage
        case .approaching: Color(red: 0.67, green: 0.47, blue: 0.13)  // deep amber
        case .overdue: Color(red: 0.66, green: 0.32, blue: 0.25)      // deep terracotta
        }
    }

    private func dueText(hours: Double) -> String {
        if hours <= 0 {
            let overdueHours = abs(hours)
            if overdueHours < 1 {
                return "Overdue by \(Int(overdueHours * 60))m"
            } else if overdueHours < 48 {
                return "Overdue by \(Int(overdueHours))h"
            } else {
                return "Overdue by \(Int(overdueHours / 24))d"
            }
        } else if hours < 1 {
            return "Due in \(Int(hours * 60))m"
        } else if hours < 48 {
            return "Due in \(Int(hours))h"
        } else {
            return "Due in \(Int(hours / 24))d"
        }
    }
}

#Preview {
    LazyVGrid(columns: [GridItem(.flexible())], spacing: 12) {
        FolkTileView(folk: {
            let f = Folk(userAssignedName: "Mom", targetCallFrequencyInHours: 168,
                         lastCallDate: Date().addingTimeInterval(-3 * 24 * 3600))
            f.streak = 5
            return f
        }())
        FolkTileView(folk: {
            let f = Folk(userAssignedName: "Dad", targetCallFrequencyInHours: 168,
                         lastCallDate: Date().addingTimeInterval(-6.5 * 24 * 3600))
            f.streak = 3
            return f
        }())
        FolkTileView(folk: Folk(userAssignedName: "Uncle Bob", targetCallFrequencyInHours: 2160))
    }
    .padding()
}
