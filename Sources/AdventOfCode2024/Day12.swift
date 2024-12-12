import AdventOfCodeKit
import DequeModule

public struct Day12: Sendable {
    public static let sample = """
        AAAA
        BBCD
        BBCC
        EEEC
        """

    public static let sample2 = """
        RRRRIICCFF
        RRRRIICCCF
        VVRRRCCFFF
        VVRCCCJFFF
        VVVVCJJCFE
        VVIVCCJJEE
        VVIIICJJEE
        MIIIIIJJEE
        MIIISIJEEE
        MMMISSJEEE
        """

    public static let noncontiguousSample = """
        OOOOO
        OXOXO
        OOOOO
        OXOXO
        OOOOO
        """

    public static let eSample = """
        EEEEE
        EXXXX
        EEEEE
        EXXXX
        EEEEE
        """

    public static let abSample = """
        AAAAAA
        AAABBA
        AAABBA
        ABBAAA
        ABBAAA
        AAAAAA
        """

    public let input: String

    public init(
        input: String? = nil
    ) {
        let inputText =
            if let input {
                input
            } else if let input = try? Input.day(12) {
                input
            } else {
                Self.sample
            }
        self.input = inputText
    }

    struct Patch: Hashable {
        private(set) var points: Set<Point>
        let id: Character

        mutating func add(_ point: Point) {
            points.insert(point)
        }

        var perimeterLength: Int {
            points.reduce(0) { acc, next in
                acc + next.cardinalAdjacent.count(where: { !points.contains($0) })
            }
        }

        var corners: Int {
            points.reduce(0) { acc, next in
                var corners = 0
                if !points.contains(next.north) {
                    if !points.contains(next.east) {
                        corners += 1
                    }
                    if !points.contains(next.west) {
                        corners += 1
                    }
                }

                if !points.contains(next.south) {
                    if !points.contains(next.east) {
                        corners += 1
                    }
                    if !points.contains(next.west) {
                        corners += 1
                    }
                }

                if points.contains(next.north) {
                    if points.contains(next.east) && !points.contains(next.northEast) {
                        corners += 1
                    }
                    if points.contains(next.west) && !points.contains(next.northWest) {
                        corners += 1
                    }
                }

                if points.contains(next.south) {
                    if points.contains(next.east) && !points.contains(next.southEast) {
                        corners += 1
                    }
                    if points.contains(next.west) && !points.contains(next.southWest) {
                        corners += 1
                    }
                }

                return acc + corners
            }
        }

        var fencePrice: Int {
            points.count * perimeterLength
        }

        var bulkDiscountPrice: Int {
            points.count * corners
        }
    }

    public func solvePart1() async throws -> Int {
        let garden = Matrix(string: input)
        var visited = Set<Point>()
        var patches = Set<Patch>()

        garden.forEachPoint { char, point in
            let (inserted, _) = visited.insert(point)
            if inserted {
                var newPatch = Patch(points: [point], id: char)
                var pointsToVisit = Deque<Point>()
                pointsToVisit.append(contentsOf: point.cardinalAdjacent)
                while let adjacent = pointsToVisit.popFirst() {
                    if let adjacentValue = garden.at(point: adjacent),
                        char == adjacentValue,
                        !visited.contains(adjacent)
                    {
                        visited.insert(adjacent)
                        newPatch.add(adjacent)
                        pointsToVisit.append(contentsOf: adjacent.cardinalAdjacent)
                    }
                }
                patches.insert(newPatch)
            }
        }

        return patches.map(\.fencePrice).reduce(0, +)
    }

    public func solvePart2() async throws -> Int {
        let garden = Matrix(string: input)
        var visited = Set<Point>()
        var patches = Set<Patch>()

        garden.forEachPoint { char, point in
            let (inserted, _) = visited.insert(point)
            if inserted {
                var newPatch = Patch(points: [point], id: char)
                var pointsToVisit = Deque<Point>()
                pointsToVisit.append(contentsOf: point.cardinalAdjacent)
                while let adjacent = pointsToVisit.popFirst() {
                    if let adjacentValue = garden.at(point: adjacent),
                        char == adjacentValue,
                        !visited.contains(adjacent)
                    {
                        visited.insert(adjacent)
                        newPatch.add(adjacent)
                        pointsToVisit.append(contentsOf: adjacent.cardinalAdjacent)
                    }
                }
                patches.insert(newPatch)
            }
        }

        return patches.map(\.bulkDiscountPrice).reduce(0, +)
    }
}
