import AdventOfCodeKit

public struct Day10: Sendable {
    public static let sampleScore2 = """
        ...0...
        ...1...
        ...2...
        6543456
        7.....7
        8.....8
        9.....9
        """

    public static let sampleScore4 = """
        ..90..9
        ...1.98
        ...2..7
        6543456
        765.987
        876....
        987....
        """

    public static let sampleScore3 = """
        10..9..
        2...8..
        3...7..
        4567654
        ...8..3
        ...9..2
        .....01
        """

    public static let sampleScore36 = """
        89010123
        78121874
        87430965
        96549874
        45678903
        32019012
        01329801
        10456732
        """

    public static let sampleRating3 = """
        .....0.
        ..4321.
        ..5..2.
        ..6543.
        ..7..4.
        ..8765.
        ..9....
        """

    public static let sampleRating13 = """
        ..90..9
        ...1.98
        ...2..7
        6543456
        765.987
        876....
        987....
        """

    public static let sampleRating227 = """
        012345
        123456
        234567
        345678
        4.6789
        56789.
        """

    public static let sampleRating81 = """
        89010123
        78121874
        87430965
        96549874
        45678903
        32019012
        01329801
        10456732
        """

    public let input: String

    public init(
        input: String? = nil
    ) {
        let inputText =
            if let input {
                input
            } else if let input = try? Input.day(10) {
                input
            } else {
                Self.sampleScore2
            }
        self.input = inputText
    }

    struct Position: Hashable, Identifiable {
        let point: Point
        let value: Int
        let id: String

        init(point: Point, value: Int) {
            self.point = point
            self.value = value
            self.id = "\(point.x)-\(point.y)-\(value)"
        }
    }

    enum TrailMarker {
        case value(Int)
        case impassable

        init(character: Character) {
            if let value = Int(String(character)) {
                self = .value(value)
            } else {
                self = .impassable
            }
        }
    }

    public func solvePart1() async throws -> Int {
        let map = Matrix(string: input).map({ char, _ in
            TrailMarker(character: char)
        })
        var items = [Position]()
        var lookupMap = [Position.ID: [Position.ID]]()

        var startingPoints = Set<Position>()
        var endingPoints = Set<Position>()

        map.forEachPoint { trailMarker, point in
            switch trailMarker {
            case .value(let value):
                let position = Position(point: point, value: value)
                items.append(position)

                switch value {
                case 0:
                    startingPoints.insert(position)
                case 9:
                    endingPoints.insert(position)
                default:
                    break
                }

                for adjacent in point.cardinalAdjacent {
                    if let adjacentMarker = map.at(point: adjacent) {
                        switch adjacentMarker {
                        case .value(let adjacentValue):
                            if adjacentValue == value + 1 {
                                let adjacentPosition = Position(point: adjacent, value: adjacentValue)
                                var traversable = lookupMap[position.id, default: []]
                                traversable.append(adjacentPosition.id)
                                lookupMap[position.id] = traversable
                            }
                        case .impassable:
                            continue
                        }
                    }
                }
            case .impassable:
                break
            }
        }

        let graph = Graph(items: items, map: lookupMap)

        var trails = 0
        for startingPoint in startingPoints {
            for endingPoint in endingPoints {
                let path = graph.breadthFirstSearch(from: startingPoint, to: endingPoint)
                if !path.isEmpty {
                    trails += 1
                }
            }
        }
        return trails
    }

    public func solvePart2() async throws -> Int {
        let map = Matrix(string: input).map({ char, _ in TrailMarker(character: char) })
        var items = [Position]()
        var lookupMap = [Position.ID: [Position.ID]]()

        var startingPoints = Set<Position>()
        var endingPoints = Set<Position>()

        map.forEachPoint { trailMarker, point in
            switch trailMarker {
            case .value(let value):
                let position = Position(point: point, value: value)
                items.append(position)

                switch value {
                case 0:
                    startingPoints.insert(position)
                case 9:
                    endingPoints.insert(position)
                default:
                    break
                }

                for adjacent in point.cardinalAdjacent {
                    if let adjacentMarker = map.at(point: adjacent) {
                        switch adjacentMarker {
                        case .value(let adjacentValue):
                            if adjacentValue == value + 1 {
                                let adjacentPosition = Position(point: adjacent, value: adjacentValue)
                                var traversable = lookupMap[position.id, default: []]
                                traversable.append(adjacentPosition.id)
                                lookupMap[position.id] = traversable
                            }
                        case .impassable:
                            continue
                        }
                    }
                }
            case .impassable:
                break
            }
        }

        let graph = Graph(items: items, map: lookupMap)

        var rating = 0
        for startingPoint in startingPoints {
            for endingPoint in endingPoints {
                let paths = graph.findAllPaths(from: startingPoint, to: endingPoint)
                rating += paths.count
            }
        }
        return rating

    }
}
