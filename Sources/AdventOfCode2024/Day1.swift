import AdventOfCodeKit

public struct Day1 {
    public static let sample = """
        3   4
        4   3
        2   5
        1   3
        3   9
        3   3
        """

    public let input: String

    let firsts: [Int]
    let seconds: [Int]
    let counts: [Int: Int]

    public init(
        input: String? = nil
    ) {
        let inputText =
            if let input {
                input
            } else if let input = try? Input.day(1) {
                input
            } else {
                Self.sample
            }

        self.input = inputText
        let pairs = inputText.lines.map { line in
            let numbers = line.components(separatedBy: .whitespaces).compactMap(Int.init)
            return (numbers[0], numbers[1])
        }
        firsts = pairs.map(\.0)
        seconds = pairs.map(\.1)

        counts = Dictionary.init(grouping: seconds) { element in
            element
        }.mapValues { values in
            values.count
        }
    }

    public func solvePart1() throws -> Int {
        zip(firsts.sorted(), seconds.sorted()).reduce(0) { acc, next in
            acc + abs(next.0 - next.1)
        }
    }

    public func solvePart2() throws -> Int {
        zip(firsts.sorted(), seconds.sorted()).reduce(0) { acc, next in
            acc + abs(next.0 * counts[next.0, default: 0])
        }
    }
}
