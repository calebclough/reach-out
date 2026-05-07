import SwiftUI

struct StreakBadgeView: View {
    let streak: Int

    var body: some View {
        if streak > 0 {
            HStack(spacing: 3) {
                Image(systemName: "flame.fill")
                    .foregroundStyle(.orange)
                Text("\(streak)")
                    .fontWeight(.bold)
            }
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(.ultraThinMaterial, in: Capsule())
        }
    }
}

#Preview {
    VStack(spacing: 12) {
        StreakBadgeView(streak: 0)
        StreakBadgeView(streak: 1)
        StreakBadgeView(streak: 12)
    }
}
