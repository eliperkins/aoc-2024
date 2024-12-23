public struct Point: Hashable, Sendable {
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

    public static let zero = Point(x: 0, y: 0)

    @inlinable
    @inline(__always)
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

    @inlinable
    @inline(__always)
    public var cardinalAdjacent: Set<Point> {
        [
            north,
            east,
            south,
            west,
        ]
    }

    @inlinable
    @inline(__always)
    public var corners: Set<Point> {
        [
            Point(x: x + 1, y: y + 1),
            Point(x: x + 1, y: y - 1),
            Point(x: x - 1, y: y + 1),
            Point(x: x - 1, y: y - 1),
        ]
    }

    @inlinable
    @inline(__always)
    public func lines(ofLength length: Int) -> [[Point]] {
        let traversalRange = 0..<length
        return [
            traversalRange.map { i in Point(x: self.x + i, y: self.y) },
            traversalRange.map { i in Point(x: self.x, y: self.y + i) },
            traversalRange.map { i in Point(x: self.x - i, y: self.y) },
            traversalRange.map { i in Point(x: self.x, y: self.y - i) },
        ]
    }

    @inlinable
    @inline(__always)
    public func diagonals(ofLength length: Int) -> [[Point]] {
        let traversalRange = 0..<length
        return [
            traversalRange.map { i in Point(x: self.x + i, y: self.y + i) },
            traversalRange.map { i in Point(x: self.x + i, y: self.y - i) },
            traversalRange.map { i in Point(x: self.x - i, y: self.y + i) },
            traversalRange.map { i in Point(x: self.x - i, y: self.y - i) },
        ]
    }

    @inlinable
    @inline(__always)
    public func centeredDiagonals(ofLength length: Int) -> [[Point]] {
        let traversalRange = stride(from: -length, through: length, by: 1)
        return [
            traversalRange.map { i in Point(x: self.x + i, y: self.y + i) },
            traversalRange.map { i in Point(x: self.x + i, y: self.y - i) },
            traversalRange.map { i in Point(x: self.x - i, y: self.y + i) },
            traversalRange.map { i in Point(x: self.x - i, y: self.y - i) },
        ]
    }

    @inlinable
    @inline(__always)
    public func manhattanDistance(to point: Point) -> Int {
        let x = abs(x - point.x)
        let y = abs(y - point.y)
        return x + y
    }

    @inlinable
    @inline(__always)
    public var north: Point {
        Point(x: self.x, y: self.y - 1)
    }

    @inlinable
    @inline(__always)
    public var south: Point {
        Point(x: self.x, y: self.y + 1)
    }

    @inlinable
    @inline(__always)
    public var east: Point {
        Point(x: self.x + 1, y: self.y)
    }

    @inlinable
    @inline(__always)
    public var west: Point {
        Point(x: self.x - 1, y: self.y)
    }

    @inlinable
    @inline(__always)
    public var northEast: Point {
        Point(x: self.x + 1, y: self.y - 1)
    }

    @inlinable
    @inline(__always)
    public var southEast: Point {
        Point(x: self.x + 1, y: self.y + 1)
    }

    @inlinable
    @inline(__always)
    public var southWest: Point {
        Point(x: self.x - 1, y: self.y + 1)
    }

    @inlinable
    @inline(__always)
    public var northWest: Point {
        Point(x: self.x - 1, y: self.y - 1)
    }

}
