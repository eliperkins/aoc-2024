public struct Matrix<T>: CustomDebugStringConvertible {
    @usableFromInline
    private(set) var _rows: [[T]]

    @usableFromInline
    private(set) var _columns: [[T]]

    public init(_ xs: [[T]]) {
        _rows = xs
        let columns = xs[0].indices.map { index in
            xs.map { $0[index] }
        }
        self._columns = columns
    }

    public init(rows: [[T]]) {
        self.init(rows)
    }

    public init(columns: [[T]]) {
        _columns = columns
        _rows = columns[0].indices.map { index in
            columns.map { $0[index] }
        }
    }

    public init(
        repeating: T,
        width: Int,
        height: Int
    ) {
        self.init([[T]](repeating: [T](repeating: repeating, count: width), count: height))
    }

    public var rows: [[T]] {
        _rows
    }

    public var columns: [[T]] {
        _columns
    }

    @inlinable
    @inline(__always)
    public func atPosition(x: Int, y: Int) -> T? {
        if rows.indices.contains(y) {
            let row = rows[y]
            if row.indices.contains(x) {
                return row[x]
            }
        }

        return nil
    }

    @inlinable
    @inline(__always)
    public func at(point: Point) -> T? {
        atPosition(x: point.x, y: point.y)
    }

    @inlinable
    @inline(__always)
    public mutating func set(value: T, x: Int, y: Int) {
        if rows.indices.contains(y) {
            let row = rows[y]
            if row.indices.contains(x) {
                _rows[y][x] = value
                _columns[x][y] = value
            }
        }
    }

    @inlinable
    @inline(__always)
    public mutating func set(value: T, point: Point) {
        set(value: value, x: point.x, y: point.y)
    }

    @inlinable
    @inline(__always)
    public func forEachPosition(_ fn: (T, (x: Int, y: Int)) -> Void) {
        rows.enumerated().forEach { (rowIndex, row) in
            row.enumerated().forEach { (columnIndex, item) in
                fn(item, (x: columnIndex, y: rowIndex))
            }
        }
    }

    @inlinable
    @inline(__always)
    public func forEachPoint(_ fn: (T, Point) -> Void) {
        rows.enumerated().forEach { (rowIndex, row) in
            row.enumerated().forEach { (columnIndex, item) in
                fn(item, Point(x: columnIndex, y: rowIndex))
            }
        }
    }

    @inlinable
    @inline(__always)
    public func map<U>(_ fn: (T, (x: Int, y: Int)) -> U) -> Matrix<U> {
        Matrix<U>(
            rows.enumerated().map { (rowIndex, row) in
                row.enumerated().map { (columnIndex, item) in
                    fn(item, (x: columnIndex, y: rowIndex))
                }
            }
        )
    }

    @inlinable
    @inline(__always)
    public func collect(_ predicate: (T, (x: Int, y: Int)) -> Bool) -> [T] {
        var output = [T]()
        rows.enumerated().forEach { (rowIndex, row) in
            row.enumerated().forEach { (columnIndex, item) in
                if predicate(item, (x: columnIndex, y: rowIndex)) {
                    output.append(item)
                }
            }
        }
        return output
    }

    @inlinable
    @inline(__always)
    public func collectLocations(
        _ predicate: (T, (x: Int, y: Int)) -> Bool
    ) -> [(
        T, (x: Int, y: Int)
    )] {
        var output = [(T, (x: Int, y: Int))]()
        rows.enumerated().forEach { (rowIndex, row) in
            row.enumerated().forEach { (columnIndex, item) in
                if predicate(item, (x: columnIndex, y: rowIndex)) {
                    output.append((item, (x: columnIndex, y: rowIndex)))
                }
            }
        }
        return output
    }

    @inlinable
    @inline(__always)
    public func first(where fn: (T) -> Bool) -> T? {
        for row in rows {
            for item in row where fn(item) {
                return item
            }
        }
        return nil
    }

    @inlinable
    @inline(__always)
    public func firstPosition(where fn: (T) -> Bool) -> (x: Int, y: Int)? {
        for (y, row) in rows.enumerated() {
            for (x, item) in row.enumerated() where fn(item) {
                return (x: x, y: y)
            }
        }
        return nil
    }
}

extension Matrix {
    public var debugDescription: String {
        rows.map { $0.debugDescription }.joined(separator: "\n")
    }
}

extension Matrix where T == String {
    public var debugDescription: String {
        rows.map { $0.joined() }.joined(separator: "\n")
    }
}

extension Matrix where T == Character {
    public init(string: String) {
        self.init(string.lines.map(Array.init))
    }

    public var debugDescription: String {
        rows.map { String($0) }.joined(separator: "\n")
    }
}

extension Matrix where T == Int {
    public var debugDescription: String {
        let maxWidth = rows.flatMap { $0 }.max().flatMap(String.init)?.count ?? 1
        return
            rows
            .map { row in
                row
                    .map { value in value.description.padding(toLength: maxWidth, withPad: " ", startingAt: 0)
                    }
                    .joined(separator: ", ")
            }
            .joined(separator: "\n")
    }
}
extension Matrix where T: RawRepresentable, T.RawValue == Character {
    public var debugDescription: String {
        rows.map { String($0.map(\.rawValue)) }.joined(separator: "\n")
    }
}

extension Matrix: Equatable where T: Equatable {}
extension Matrix: Hashable where T: Hashable {}
