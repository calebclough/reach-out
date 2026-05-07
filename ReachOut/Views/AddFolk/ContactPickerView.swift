import SwiftUI
import ContactsUI

struct ContactPickerView: UIViewControllerRepresentable {
    @Binding var selectedName: String
    @Binding var selectedNumbers: [String]
    @Binding var selectedImageData: Data?
    @Environment(\.dismiss) private var dismiss

    func makeUIViewController(context: Context) -> CNContactPickerViewController {
        let picker = CNContactPickerViewController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: CNContactPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, CNContactPickerDelegate {
        let parent: ContactPickerView

        init(_ parent: ContactPickerView) {
            self.parent = parent
        }

        func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
            let fullName = CNContactFormatter.string(from: contact, style: .fullName) ?? ""
            if !fullName.isEmpty {
                parent.selectedName = fullName
            }

            let numbers = contact.phoneNumbers.map { $0.value.stringValue }
            if !numbers.isEmpty {
                parent.selectedNumbers = numbers
            }

            parent.selectedImageData = contact.thumbnailImageData
        }

        func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
            parent.dismiss()
        }
    }
}
