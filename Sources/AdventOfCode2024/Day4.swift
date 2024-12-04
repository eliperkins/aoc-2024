import AdventOfCodeKit

public struct Day4 {
    public static let sample = """
        MMMSXXMASM
        MSAMXMSMSA
        AMXSXMAAMM
        MSAMASMSMX
        XMASAMXAMM
        XXAMMXXAMA
        SMSMSASXSS
        SAXAMASAAA
        MAMMMXMMMM
        MXMXAXMASX
        """

    public let input: String

    public init(
        input: String? = nil
    ) {
        let inputText =
            if let input {
                input
            } else if let input = try? Input.day(4) {
                input
            } else {
                Self.sample
            }
        self.input = inputText
    }

    public func solvePart1() throws -> Int {
        let searchTerm = "XMAS".unicodeScalars.map(Character.init)
        let wordSearch = Matrix(input.lines.map { $0.unicodeScalars.map(Character.init) })
        let startingLocations = wordSearch.collectLocations { character, _ in
            character == "X"
        }
        return startingLocations.reduce(0) { acc, next in
            let (_, loc) = next
            let startingPoint = Point(x: loc.x, y: loc.y)

            let searches =
                startingPoint.lines(ofLength: searchTerm.count)
                + startingPoint.diagonals(ofLength: searchTerm.count)

            let count = searches.count(where: { range in
                range.compactMap { wordSearch.at(point: $0) } == searchTerm
            })

            return acc + count
        }
    }

    public func solvePart2() throws -> Int {
        let searchTerm = "MAS".unicodeScalars.map(Character.init)
        let wordSearch = Matrix(input.lines.map { $0.unicodeScalars.map(Character.init) })
        let startingLocations = wordSearch.collectLocations { character, _ in
            character == "A"
        }
        return startingLocations.reduce(0) { acc, next in
            let (_, loc) = next
            let startingPoint = Point(x: loc.x, y: loc.y)

            let diagonals = startingPoint.centeredDiagonals(ofLength: 1)

            let count = diagonals.count(where: { range in
                range.compactMap { wordSearch.at(point: $0) } == searchTerm
            })

            return count == 2 ? acc + 1 : acc
        }
    }
}
