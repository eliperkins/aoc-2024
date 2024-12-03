import Algorithms
import Foundation

extension String {
    public var lines: [String] {
        var lines = [String]()
        enumerateLines { (line, _) in
            lines.append(line)
        }
        return lines
    }
}

extension String {
    public var paragraphs: [ArraySlice<String>] {
        lines.chunked(by: { _, str in !str.isEmpty })
    }
}
