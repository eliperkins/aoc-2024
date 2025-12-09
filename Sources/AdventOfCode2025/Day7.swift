import AdventOfCodeKit

public struct Day7: Sendable {
  public static let sample = """
    .......S.......
    ...............
    .......^.......
    ...............
    ......^.^......
    ...............
    .....^.^.^.....
    ...............
    ....^.^...^....
    ...............
    ...^.^...^.^...
    ...............
    ..^...^.....^..
    ...............
    .^.^.^.^.^...^.
    ...............
    """

  public let input: String

  public init(
    input: String? = nil
  ) {
    let inputText =
      if let input {
        input
      } else if let input = try? Input.day(7) {
        input
      } else {
        Self.sample
      }
    self.input = inputText
  }

  public func solvePart1() async throws -> Int {
    var matrix = Matrix(string: input)
    guard let startingPoint = matrix.firstPosition(where: { $0 == "S" }) else {
      fatalError("No starting point found")
    }
    var currentY = startingPoint.y + 1
    var splits = 0
    while currentY < matrix.rows.count {
      let previousRow = matrix.rows[currentY - 1]
      let currentRow = matrix.rows[currentY]
      for (offset, pair) in zip(previousRow, currentRow).enumerated() {
        switch pair {
        case ("S", "^"), ("|", "^"):
          splits += 1
          matrix.set(value: "|", x: offset - 1, y: currentY)
          matrix.set(value: "|", x: offset + 1, y: currentY)
        case ("S", _), ("|", _):
          matrix.set(value: "|", x: offset, y: currentY)
        default:
          continue
        }
      }
      currentY += 1
    }
    return splits
  }

  public func solvePart2() async throws -> Int {
    var matrix = Matrix(string: input)
    var counters = Matrix<Int>(repeating: 0, width: matrix.columns.count, height: matrix.rows.count)
    guard let startingPoint = matrix.firstPosition(where: { $0 == "S" }) else {
      fatalError("No starting point found")
    }
    counters.set(value: 1, x: startingPoint.x, y: startingPoint.y)
    var currentY = startingPoint.y + 1
    while currentY < matrix.rows.count {
      let previousRow = matrix.rows[currentY - 1]
      let currentRow = matrix.rows[currentY]
      for (offset, pair) in zip(previousRow, currentRow).enumerated() {
        switch pair {
        case ("S", "^"), ("|", "^"):
          matrix.set(value: "|", x: offset - 1, y: currentY)
          matrix.set(value: "|", x: offset + 1, y: currentY)
          let count = counters.atPosition(x: offset, y: currentY - 1) ?? 0
          counters.set(value: { value in value + count }, x: offset - 1, y: currentY)
          counters.set(value: { value in value + count }, x: offset + 1, y: currentY)
        case ("S", _), ("|", _):
          matrix.set(value: "|", x: offset, y: currentY)
          let count = counters.atPosition(x: offset, y: currentY - 1) ?? 0
          counters.set(value: { value in value + count }, x: offset, y: currentY)
        default:
          continue
        }
      }
      currentY += 1
    }
    return counters.rows.last?.sum() ?? 0
  }
}
