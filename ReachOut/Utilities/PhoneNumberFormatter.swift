import Foundation

enum PhoneNumberFormatter {
    /// Strips a display number down to digits and leading '+' for use in tel: URLs.
    static func sanitize(_ number: String) -> String {
        let allowed = CharacterSet(charactersIn: "+0123456789")
        return String(number.unicodeScalars.filter { allowed.contains($0) })
    }

    /// Builds a tel: URL from a display phone number.
    static func telURL(for number: String) -> URL? {
        let sanitized = sanitize(number)
        guard !sanitized.isEmpty else { return nil }
        return URL(string: "tel:\(sanitized)")
    }
}
