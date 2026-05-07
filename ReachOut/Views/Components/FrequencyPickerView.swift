import SwiftUI

struct FrequencyPickerView: View {
    @Binding var frequencyInHours: Int

    private enum Preset: String, CaseIterable, Identifiable {
        case daily = "Daily"
        case weekly = "Weekly"
        case biweekly = "Biweekly"
        case monthly = "Monthly"
        case quarterly = "Quarterly"

        var id: String { rawValue }

        var hours: Int {
            switch self {
            case .daily: 24
            case .weekly: 168
            case .biweekly: 336
            case .monthly: 720
            case .quarterly: 2160
            }
        }

        init?(hours: Int) {
            switch hours {
            case 24: self = .daily
            case 168: self = .weekly
            case 336: self = .biweekly
            case 720: self = .monthly
            case 2160: self = .quarterly
            default: return nil
            }
        }
    }

    var body: some View {
        Picker("Frequency", selection: frequencyBinding) {
            ForEach(Preset.allCases) { preset in
                Text(preset.rawValue).tag(preset)
            }
        }
        .pickerStyle(.segmented)
    }

    private var frequencyBinding: Binding<Preset> {
        Binding(
            get: { Preset(hours: frequencyInHours) ?? .weekly },
            set: { frequencyInHours = $0.hours }
        )
    }
}

#Preview {
    @Previewable @State var freq = 168
    VStack {
        FrequencyPickerView(frequencyInHours: $freq)
        Text("Every \(freq) hours")
    }
    .padding()
}
