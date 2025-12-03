import AdventOfCodeKit
import Foundation

public struct Day3: Sendable {
  public static let sample = """
    987654321111111
    811111111111119
    234234234234278
    818181911112111
    """

  public let input: String

  public init(
    input: String? = nil
  ) {
    let inputText =
      if let input {
        input
      } else if let input = try? Input.day(3) {
        input
      } else {
        Self.sample
      }
    self.input = inputText
  }

  func joltageDigit<C: Collection>(
    in bank: C,
    boundedBy count: Int
  ) -> (Int, C.Index)? where C.Element == Int, C.Index == Int {
    for i in (1...9).reversed() {
      if let firstIndex = bank.firstIndex(of: i),
        bank.indices.contains(firstIndex.advanced(by: count))
      {
        return (i, firstIndex)
      }
    }
    return nil
  }

  func joltage(in bank: [Int], count: Int) -> Int {
    var output = [Int]()
    var working = bank.suffix(from: 0)
    for count in (0..<count).reversed() {
      if let (digit, index) = joltageDigit(in: working, boundedBy: count) {
        output.append(digit)
        working = working.suffix(from: index.advanced(by: 1))
      }
    }
    let result = zip(output, (0..<count).reversed()).reduce(0) { acc, next in
      let (value, exp) = next
      let x = value * Int(pow(Double(10), Double(exp)))
      return acc + x
    }
    return result
  }

  public func solvePart1() async throws -> Int {
    input.lines.map { line in
      let bank = line.map(String.init).compactMap(Int.init)
      return joltage(in: bank, count: 2)
    }.reduce(0, +)
  }

  public func solvePart2() async throws -> Int {
    input.lines.map { line in
      let bank = line.map(String.init).compactMap(Int.init)
      return joltage(in: bank, count: 12)
    }.reduce(0, +)
  }
}
