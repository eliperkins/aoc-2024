import AdventOfCodeKit
import Algorithms

public struct Day9: Sendable {
  public static let sample = """
    7,1
    11,1
    11,7
    9,7
    9,5
    2,5
    2,3
    7,3
    """

  public let input: String

  public init(
    input: String? = nil
  ) {
    let inputText =
      if let input {
        input
      } else if let input = try? Input.day(9) {
        input
      } else {
        Self.sample
      }
    self.input = inputText
  }

  public func solvePart1() async throws -> Int {
    let points: [Point] = input.lines.compactMap { line in
      let parts = line.split(separator: ",")
      guard let x = Int(parts[0]), let y = Int(parts[1]) else { return nil }
      return Point(x: x, y: y)
    }
    return points.combinations(ofCount: 2).map { pairs in
      let a = pairs[0]
      let b = pairs[1]
      let dx = abs(a.x - b.x) + 1
      let dy = abs(a.y - b.y) + 1
      return dx * dy
    }.max() ?? 0
  }

  public func solvePart2() async throws -> Int {
    let points: [Point] = input.lines.compactMap { line in
      let parts = line.split(separator: ",")
      guard let x = Int(parts[0]), let y = Int(parts[1]) else { return nil }
      return Point(x: x, y: y)
    }
    let maxX = points.map(\.x).max() ?? 0
    let maxY = points.map(\.y).max() ?? 0

    print("Creating \(maxX + 2) x \(maxY + 2) matrix...")

    var matrix = Matrix(repeating: ".", width: maxX + 2, height: maxY + 2)

    guard let start = points.first else { return 0 }

    print("Processing \(points.count) points...")

    for pair in zip(points, Array(points.dropFirst() + [start])) {
      let a = pair.0
      let b = pair.1

      matrix.set(value: "#", x: a.x, y: a.y)

      if a.x == b.x {
        print("Vertical line from \(a) to \(b)")
        if a.y < b.y {
          for y in (a.y + 1)..<b.y {
            matrix.set(value: "X", x: a.x, y: y)
          }
        } else {
          for y in (b.y + 1)..<a.y {
            matrix.set(value: "X", x: a.x, y: y)
          }
        }
      } else {
        print("Horizontal line from \(a) to \(b)")
        if a.x < b.x {
          for x in (a.x + 1)..<b.x {
            matrix.set(value: "X", x: x, y: a.y)
          }
        } else {
          for x in (b.x + 1)..<a.x {
            matrix.set(value: "X", x: x, y: a.y)
          }
        }
      }
    }

    print(matrix.debugDescription)

    return points.combinations(ofCount: 2).map { pairs in
      let a = pairs[0]
      let b = pairs[1]

      let dx = abs(a.x - b.x) + 1
      let dy = abs(a.y - b.y) + 1
      return dx * dy
    }.max() ?? 0
  }
}
