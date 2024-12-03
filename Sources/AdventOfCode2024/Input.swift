import Foundation

public enum Input {
    public static func day(_ dayValue: Int) throws -> String {
        let url = Bundle.module.url(forResource: "Inputs/day\(dayValue)", withExtension: "txt")!
        return try String(contentsOf: url).trimmingCharacters(in: .newlines)
    }
}
