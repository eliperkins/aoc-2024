public struct Point: Hashable {
    public var x: Int
    public var y: Int

    public init(
        x: Int, y: Int
    ) {
        self.x = x
        self.y = y
    }

    public init(
        _ coordinates: (Int, Int)
    ) {
        self.x = coordinates.0
        self.y = coordinates.1
    }

    public var adjacent: Set<Point> {
        [
            Point(x: x + 1, y: y),
            Point(x: x + 1, y: y + 1),
            Point(x: x + 1, y: y - 1),
            Point(x: x - 1, y: y),
            Point(x: x - 1, y: y + 1),
            Point(x: x - 1, y: y - 1),
            Point(x: x, y: y + 1),
            Point(x: x, y: y - 1),
        ]
    }

    public var cardinalAdjacent: Set<Point> {
        [
            Point(x: x + 1, y: y),
            Point(x: x - 1, y: y),
            Point(x: x, y: y + 1),
            Point(x: x, y: y - 1),
        ]
    }

    public func manhattanDistance(to point: Point) -> Int {
        let x = abs(x - point.x)
        let y = abs(y - point.y)
        return x + y
    }
}
