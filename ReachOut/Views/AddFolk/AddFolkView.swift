import SwiftUI
import SwiftData

struct AddFolkView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var phoneNumbers: [String] = [""]
    @State private var frequencyInHours = 168
    @State private var showingContactPicker = false
    @State private var imageData: Data?

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $name)
                        .textContentType(.name)

                    Button {
                        showingContactPicker = true
                    } label: {
                        Label("Import from Contacts", systemImage: "person.crop.circle.badge.plus")
                    }
                }

                Section("Phone Numbers") {
                    ForEach(phoneNumbers.indices, id: \.self) { index in
                        HStack {
                            TextField("Phone number", text: $phoneNumbers[index])
                                .textContentType(.telephoneNumber)
                                .keyboardType(.phonePad)

                            if phoneNumbers.count > 1 {
                                Button(role: .destructive) {
                                    phoneNumbers.remove(at: index)
                                } label: {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundStyle(.red)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }

                    if phoneNumbers.count < 5 {
                        Button {
                            phoneNumbers.append("")
                        } label: {
                            Label("Add Number", systemImage: "plus.circle")
                        }
                    }
                }

                Section("How often do you want to call?") {
                    FrequencyPickerView(frequencyInHours: $frequencyInHours)
                }
            }
            .navigationTitle("Add Folk")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") { saveFolk() }
                        .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .sheet(isPresented: $showingContactPicker) {
                ContactPickerView(
                    selectedName: $name,
                    selectedNumbers: $phoneNumbers,
                    selectedImageData: $imageData
                )
            }
        }
    }

    private func saveFolk() {
        let cleanNumbers = phoneNumbers
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }

        let folk = Folk(
            userAssignedName: name.trimmingCharacters(in: .whitespaces),
            contactNumbers: cleanNumbers,
            targetCallFrequencyInHours: frequencyInHours,
            imageData: imageData
        )

        modelContext.insert(folk)
        NotificationService.scheduleNotification(for: folk)
        dismiss()
    }
}

#Preview {
    AddFolkView()
        .modelContainer(previewContainer)
}
