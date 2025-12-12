import AdventOfCodeKit

public struct Day10: Sendable {
  public static let sample = """
    [.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
    [...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
    [.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}
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
        Self.sample
      }
    self.input = inputText
  }

  func extract(_ line: String) -> ([Bool], [[Int]]) {
    var solution = [Bool]()
    var buttons = [[Int]]()
    for segmentString in line.split(separator: " ") {
      switch segmentString.first {
      case "(":
        let button =
          segmentString
          .dropFirst()
          .dropLast()
          .split(separator: ",")
          .compactMap { Int(String($0)) }
        buttons.append(button)

      case "{":
        break
      case "[":
        solution =
          segmentString
          .dropFirst()
          .dropLast()
          .map { char in
            if char == "#" { return true }
            if char == "." { return false }
            fatalError("Unknown solution character! \(char)")
          }
      default:
        fatalError("Unknown segment type! \(segmentString)")
      }
    }
    return (solution, buttons)
  }

  public func solvePart1() async throws -> Int {
    input.lines.map { line in
      let (solution, buttons) = extract(line)

      func press(buttons: [[Int]], size: Int) -> [Bool] {
        var lights = Array(repeating: false, count: size)
        for button in buttons {
          for i in button {
            lights[i].toggle()
          }
        }
        return lights
      }

      var count = 1
      while true {
        let permutations = buttons.permutations(ofCount: count)

        for permutation in permutations {
          let lights = press(buttons: permutation, size: solution.count)
          if lights == solution {
            return count
          }
        }

        count += 1
      }
      return 0
    }
    .sum()
  }

  public func solvePart2() async throws -> Int {
    0
  }
}
