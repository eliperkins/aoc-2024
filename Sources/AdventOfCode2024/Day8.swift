import AdventOfCodeKit

public struct Day8: Sendable {
    public static let sample = """
        ............
        ........0...
        .....0......
        .......0....
        ....0.......
        ......A.....
        ............
        ............
        ........A...
        .........A..
        ............
        ............
        """

    public let input: String

    public init(
        input: String? = nil
    ) {
        let inputText =
            if let input {
                input
            } else if let input = try? Input.day(8) {
                input
            } else {
                Self.sample
            }
        self.input = inputText
    }

    public func solvePart1() async throws -> Int {
        let map = Matrix(string: input)
        var positionsByFrequency = [Character: [Point]]()
        map.forEachPosition { value, position in
            if value != "." {
                var positions = positionsByFrequency[value, default: []]
                positions.append(Point(position))
                positionsByFrequency[value] = positions
            }
        }

        var antinodes = Set<Point>()

        for nodes in positionsByFrequency.values {
            let pairs = nodes.permutations(ofCount: 2)
            for pair in pairs {
                if let lhs = pair.first, let rhs = pair.last {
                    let xDiff = lhs.x - rhs.x
                    let yDiff = lhs.y - rhs.y
                    let antinode = Point(x: lhs.x + xDiff, y: lhs.y + yDiff)
                    if map.contains(antinode) {
                        antinodes.insert(antinode)
                    }
                }
            }
        }

        return antinodes.count
    }

    public func solvePart2() async throws -> Int {
        let map = Matrix(string: input)
        var positionsByFrequency = [Character: [Point]]()
        map.forEachPosition { value, position in
            if value != "." {
                var positions = positionsByFrequency[value, default: []]
                positions.append(Point(position))
                positionsByFrequency[value] = positions
            }
        }

        var antinodes = Set<Point>()

        for nodes in positionsByFrequency.values {
            let pairs = nodes.permutations(ofCount: 2)
            for pair in pairs {
                if let lhs = pair.first, let rhs = pair.last {
                    let xDiff = lhs.x - rhs.x
                    let yDiff = lhs.y - rhs.y
                    let points = zip(
                        stride(from: lhs.x, through: xDiff > 0 ? map.columns.count : 0, by: xDiff),
                        stride(from: lhs.y, through: yDiff > 0 ? map.rows.count : 0, by: yDiff)
                    )
                    for point in points {
                        let antinode = Point(x: point.0, y: point.1)
                        if map.contains(antinode) {
                            antinodes.insert(antinode)
                        }
                    }
                }
            }
        }

        return antinodes.count

    }
}
