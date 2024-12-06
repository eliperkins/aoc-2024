import AdventOfCodeKit

public struct Day6: Sendable {
    public static let sample = """
        ....#.....
        .........#
        ..........
        ..#.......
        .......#..
        ..........
        .#..^.....
        ........#.
        #.........
        ......#...
        """

    public let input: String

    let map: Matrix<Character>

    public init(
        input: String? = nil
    ) {
        let inputText =
            if let input {
                input
            } else if let input = try? Input.day(6) {
                input
            } else {
                Self.sample
            }
        self.input = inputText
        self.map = Matrix(string: inputText)
    }

    enum Direction: CaseIterable {
        case north
        case east
        case south
        case west

        func next() -> Direction {
            switch self {
            case .north: .east
            case .east: .south
            case .south: .west
            case .west: .north
            }
        }
    }

    enum Collision {
        case object
        case outOfBounds
    }

    enum Termination {
        case loop
        case exit(Set<Point>)
    }

    struct TraversalHistory: Hashable {
        let startingPoint: Point
        let direction: Direction
    }

    func traverse(map: Matrix<Character>, startingPoint: Point, direction: Direction) -> (Point, Collision, Set<Point>) {
        guard map.contains(startingPoint) else { fatalError("Starting point out of bounds!") }

        switch direction {
        case .north:
            let col = map.columns[startingPoint.x][0..<startingPoint.y]
            let endY: Int
            let collision: Collision
            if let objectIndex = col.lastIndex(of: "#") {
                endY = objectIndex.advanced(by: 1)
                collision = .object
            } else {
                endY = 0
                collision = .outOfBounds
            }

            let endPoint = Point(x: startingPoint.x, y: endY)
            let points = Set((endY..<startingPoint.y).map { Point(x: startingPoint.x, y: $0) })
            return (endPoint, collision, points)
        case .east:
            let row = map.rows[startingPoint.y][startingPoint.x...]
            let endX: Int
            let collision: Collision
            if let objectIndex = row.firstIndex(of: "#") {
                endX = objectIndex.advanced(by: -1)
                collision = .object
            } else {
                endX = map.columns.endIndex.advanced(by: -1)
                collision = .outOfBounds
            }

            let endPoint = Point(x: endX, y: startingPoint.y)
            let points = Set((startingPoint.x...endX).map { Point(x: $0, y: startingPoint.y) })
            return (endPoint, collision, points)
        case .south:
            let col = map.columns[startingPoint.x][startingPoint.y...]
            let endY: Int
            let collision: Collision
            if let objectIndex = col.firstIndex(of: "#") {
                endY = objectIndex.advanced(by: -1)
                collision = .object
            } else {
                endY = map.rows.endIndex.advanced(by: -1)
                collision = .outOfBounds
            }

            let endPoint = Point(x: startingPoint.x, y: endY)
            let points = Set((startingPoint.y...endY).map { Point(x: startingPoint.x, y: $0) })
            return (endPoint, collision, points)
        case .west:
            let row = map.rows[startingPoint.y][0..<startingPoint.x]
            let endX: Int
            let collision: Collision
            if let objectIndex = row.lastIndex(of: "#") {
                endX = objectIndex.advanced(by: 1)
                collision = .object
            } else {
                endX = 0
                collision = .outOfBounds
            }

            let endPoint = Point(x: endX, y: startingPoint.y)
            let points = Set((endX..<startingPoint.x).map { Point(x: $0, y: startingPoint.y) })
            return (endPoint, collision, points)
        }
    }

    func createTerminatingTraversal(map: Matrix<Character>, startingPoint: Point) -> Termination {
        var startingPoint = startingPoint

        var traversalHistory = Set<TraversalHistory>()
        var visitedPoints = Set<Point>()
        var collision: Collision?
        var direction = Direction.north

        while collision != .outOfBounds {
            let (p, c, d) = traverse(map: map, startingPoint: startingPoint, direction: direction)
            let (inserted, _) = traversalHistory.insert(
                TraversalHistory(startingPoint: startingPoint, direction: direction)
            )
            if !inserted {
                return .loop
            }

            startingPoint = p
            collision = c
            visitedPoints.formUnion(d)
            direction = direction.next()
        }

        return .exit(visitedPoints)
    }

    public func solvePart1() throws -> Int {
        guard
            let startingPosition = map.firstPosition(where: { char in
                char == "^"
            })
        else { fatalError("Missing starting position!") }

        switch createTerminatingTraversal(map: map, startingPoint: Point(startingPosition)) {
        case .exit(let visitedPoints):
            return visitedPoints.count
        case .loop:
            fatalError("Found loop when exit was expected!")
        }
    }

    public func solvePart2() async throws -> Int {
        guard
            let startingPosition = map.firstPosition(where: { char in
                char == "^"
            })
        else { fatalError("Missing starting position!") }

        let initialTraversal =
            switch createTerminatingTraversal(map: map, startingPoint: Point(startingPosition)) {
            case .exit(let visitedPoints):
                visitedPoints
            case .loop:
                fatalError("Found loop when exit was expected!")
            }

        return await withTaskGroup(of: Int.self, returning: Int.self) { group in
            for point in initialTraversal {
                group.addTask {
                    var amendedMap = map
                    amendedMap.set(value: "#", point: point)
                    switch createTerminatingTraversal(map: amendedMap, startingPoint: Point(startingPosition)) {
                    case .loop:
                        return 1
                    case .exit:
                        return 0
                    }

                }
            }
            var counter = 0
            for await task in group {
                counter += task
            }
            return counter
        }
    }
}
