import AdventOfCodeKit
import Collections

public struct Day2 {
    public static let sample = SolutionInput.sample(
        """
        7 6 4 2 1
        1 2 7 8 9
        9 7 6 2 1
        1 3 2 4 5
        8 6 4 4 1
        1 3 6 7 9
        """)

    public static let solution = SolutionInput.solution(
        try! Input.day(2)  // swiftlint:disable:this force_try
    )

    public let input: String

    let levels: [[Int]]

    public init(
        input: SolutionInput
    ) {
        self.input = input.stringValue
        self.levels = input.stringValue.lines.map { $0.components(separatedBy: .whitespaces).compactMap(Int.init) }
    }

    enum Direction {
        case ascending
        case descending
    }

    public static func isLevelSafe(_ level: [Int]) -> Bool {
        var direction: Direction?
        var currentStep = level.first!
        for step in level.dropFirst() {
            let diff = currentStep - step
            switch direction {
            case .none:
                if diff > 0 {
                    direction = .ascending
                } else {
                    direction = .descending
                }
            case .ascending:
                if diff < 0 {
                    return false
                }
            case .descending:
                if diff > 0 {
                    return false
                }
            }

            let absDiff = abs(diff)
            if absDiff < 1 || absDiff > 3 {
                return false
            }

            currentStep = step
        }

        return true
    }

    public func solvePart1() throws -> Int {
        levels.filter { Self.isLevelSafe($0) }.count
    }

    public func solvePart2() throws -> Int {
        levels.filter { level in
            let permutations = [level] + level.combinations(ofCount: level.count - 1)
            return permutations.contains(where: Self.isLevelSafe(_:))
        }.count
    }
}
