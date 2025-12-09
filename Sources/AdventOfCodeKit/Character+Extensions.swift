import Foundation

extension Character {
    public var isWhitespace: Bool {
        unicodeScalars.contains {
            CharacterSet.whitespacesAndNewlines.contains($0)
        }
    }
}
