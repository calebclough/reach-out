import SwiftUI
import SwiftData

struct FolkDetailView: View {
    @Bindable var folk: Folk
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var showingDeleteConfirmation = false
    @State private var showingSimulatorAlert = false
    @State private var isEditingFrequency = false

    var body: some View {
        List {
            statusSection
            callSection
            frequencySection
            streakSection
            dangerZone
        }
        .navigationTitle(folk.userAssignedName)
        .navigationBarTitleDisplayMode(.inline)
        .alert("Simulator", isPresented: $showingSimulatorAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Phone calls can't be made from the Simulator. The call has been logged.")
        }
        .confirmationDialog("Delete Folk", isPresented: $showingDeleteConfirmation, titleVisibility: .visible) {
            Button("Delete", role: .destructive) { deleteFolk() }
        } message: {
            Text("Remove \(folk.userAssignedName)? This can't be undone.")
        }
    }

    // MARK: - Sections

    private var statusSection: some View {
        Section {
            HStack {
                Image(systemName: folk.status.iconName)
                    .foregroundStyle(folk.status.color)
                    .font(.title2)
                VStack(alignment: .leading) {
                    Text(folk.status.label)
                        .font(.headline)
                    if let hoursUntilDue = folk.hoursUntilDue {
                        Text(dueSummary(hours: hoursUntilDue))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    } else {
                        Text("You haven't called \(folk.userAssignedName) yet")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }

    private var callSection: some View {
        Section("Call") {
            if folk.contactNumbers.isEmpty {
                Text("No phone numbers")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(folk.contactNumbers, id: \.self) { number in
                    Button {
                        makeCall(number: number)
                    } label: {
                        Label(number, systemImage: "phone.fill")
                    }
                }
            }

            Button {
                logCallWithoutDialing()
            } label: {
                Label("Log call without dialing", systemImage: "checkmark.circle")
            }
            .foregroundStyle(.secondary)

            Text("Tapping Call logs this as a check-in.")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
    }

    private var frequencySection: some View {
        Section("Call Frequency") {
            if isEditingFrequency {
                FrequencyPickerView(frequencyInHours: $folk.targetCallFrequencyInHours)
                    .onChange(of: folk.targetCallFrequencyInHours) {
                        NotificationService.scheduleNotification(for: folk)
                    }
                Button("Done") {
                    isEditingFrequency = false
                }
            } else {
                HStack {
                    Text(frequencyLabel)
                    Spacer()
                    Button("Change") {
                        isEditingFrequency = true
                    }
                }
            }
        }
    }

    private var streakSection: some View {
        Section("Streak") {
            HStack {
                StreakBadgeView(streak: folk.streak)
                if folk.streak == 0 {
                    Text("No streak yet — make your first call!")
                        .foregroundStyle(.secondary)
                } else {
                    Text("consecutive on-time calls")
                        .foregroundStyle(.secondary)
                }
            }

            if let lastCallDate = folk.lastCallDate {
                HStack {
                    Text("Last called")
                    Spacer()
                    Text(lastCallDate, style: .relative)
                        .foregroundStyle(.secondary)
                    Text("ago")
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private var dangerZone: some View {
        Section {
            Button("Delete Folk", role: .destructive) {
                showingDeleteConfirmation = true
            }
        }
    }

    // MARK: - Actions

    private func makeCall(number: String) {
        #if targetEnvironment(simulator)
        folk.recordCall()
        NotificationService.scheduleNotification(for: folk)
        showingSimulatorAlert = true
        #else
        CallService.call(folk, number: number)
        #endif
    }

    private func logCallWithoutDialing() {
        folk.recordCall()
        NotificationService.scheduleNotification(for: folk)
    }

    private func deleteFolk() {
        NotificationService.cancelNotification(for: folk)
        modelContext.delete(folk)
        dismiss()
    }

    // MARK: - Helpers

    private var frequencyLabel: String {
        switch folk.targetCallFrequencyInHours {
        case 24: "Daily"
        case 168: "Weekly"
        case 336: "Biweekly"
        case 720: "Monthly"
        case 2160: "Quarterly"
        default: "Every \(folk.targetCallFrequencyInHours) hours"
        }
    }

    private func dueSummary(hours: Double) -> String {
        if hours <= 0 {
            let overdueHours = abs(hours)
            if overdueHours < 1 {
                return "Overdue by \(Int(overdueHours * 60)) minutes"
            } else if overdueHours < 48 {
                return "Overdue by \(Int(overdueHours)) hours"
            } else {
                return "Overdue by \(Int(overdueHours / 24)) days"
            }
        } else if hours < 1 {
            return "Due in \(Int(hours * 60)) minutes"
        } else if hours < 48 {
            return "Due in \(Int(hours)) hours"
        } else {
            return "Due in \(Int(hours / 24)) days"
        }
    }
}

#Preview {
    NavigationStack {
        FolkDetailView(folk: {
            let f = Folk(
                userAssignedName: "Mom",
                contactNumbers: ["+1 (555) 123-4567", "+1 (555) 999-0000"],
                targetCallFrequencyInHours: 168,
                lastCallDate: Date().addingTimeInterval(-3 * 24 * 3600)
            )
            f.streak = 5
            return f
        }())
    }
    .modelContainer(previewContainer)
}
