import AdventOfCodeKit

public struct Day1: Sendable {
  public static let sample = """
    L68
    L30
    R48
    L5
    R60
    L55
    L1
    L99
    R14
    L82
    """

  public let input: String

  public init(input: String? = nil) {
    let inputText =
      if let input {
        input
      } else if let input = try? Input.day(1) {
        input
      } else {
        Self.sample
      }
    self.input = inputText
  }

  public func solvePart1() async throws -> Int {
    var counter = 50
    var zeroes = 0
    for line in input.lines {
      guard let direction = line.first,
        let distance = Int(line.dropFirst())
      else {
        continue
      }
      switch direction {
      case "L":
        counter -= distance
      case "R":
        counter += distance
      default:
        fatalError("Invalid direction")
      }
      if counter > 0 {
        counter = counter % 100
      } else {
        counter = (100 + counter) % 100
      }

      if counter == 0 {
        zeroes += 1
      }
    }
    return zeroes
  }

  public func solvePart2() async throws -> Int {
    var counter = 50
    var passesByZero = 0
    for line in input.lines {
      guard let direction = line.first,
        let distance = Int(line.dropFirst())
      else {
        continue
      }

      let startingPosition = counter
      switch direction {
      case "L":
        counter -= distance
        let range = counter..<startingPosition
        passesByZero += range.map { 100 + $0 % 100 }.filter { $0 == 100 }.count
      case "R":
        counter += distance
        let range = startingPosition.advanced(by: 1)...counter
        passesByZero += range.map { 100 + $0 % 100 }.filter { $0 == 100 }.count
      default:
        fatalError("Invalid direction")
      }
      counter = counter % 100
    }
    return passesByZero
  }
}
