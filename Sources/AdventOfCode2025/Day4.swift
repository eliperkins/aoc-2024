import AdventOfCodeKit

public struct Day4: Sendable {
  public static let sample = """
    ..@@.@@@@.
    @@@.@.@.@@
    @@@@@.@.@@
    @.@@@@..@.
    @@.@@@@.@@
    .@@@@@@@.@
    .@.@.@.@@@
    @.@@@.@@@@
    .@@@@@@@@.
    @.@.@@@.@.
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

  public func solvePart1() async throws -> Int {
    let matrix = Matrix(string: input)
    return matrix.collectLocations { character, point in
      guard character == "@" else { return false }
      let adj = Point(x: point.x, y: point.y).adjacent.compactMap { matrix.at(point: $0) }.filter {
        $0 == "@"
      }
      return adj.count < 4
    }.count
  }

  public func solvePart2() async throws -> Int {
    var matrix = Matrix(string: input)
    var removed = 0
    func removablePositions(in matrix: Matrix<Character>) -> [(x: Int, y: Int)]? {
      let locations = matrix.collectLocations { character, point in
        guard character == "@" else { return false }
        let adj = Point(x: point.x, y: point.y)
          .adjacent
          .compactMap { matrix.at(point: $0) }
          .filter {
            $0 == "@"
          }
        return adj.count < 4
      }.map { $1 }
      if locations.isEmpty {
        return nil
      }
      return locations
    }
    while let positions = removablePositions(in: matrix) {
      for position in positions {
        matrix.set(value: ".", point: Point(x: position.x, y: position.y))
      }
      removed += positions.count
    }
    return removed
  }
}
