import AdventOfCodeKit

public struct Day5: Sendable {
  public static let sample = """
    3-5
    10-14
    16-20
    12-18

    1
    5
    8
    11
    17
    32
    """

  public let input: String

  public init(
    input: String? = nil
  ) {
    let inputText =
      if let input {
        input
      } else if let input = try? Input.day(5) {
        input
      } else {
        Self.sample
      }
    self.input = inputText
  }

  public func solvePart1() async throws -> Int {
    let sections = input.paragraphs
    guard
      let ranges = sections.first?.compactMap({ lines in
        let rangeNums = lines.split(separator: "-").compactMap({ Int($0) })
        return rangeNums[0]...rangeNums[1]
      }),
      let numbers = sections.last?.compactMap({ Int($0) })
    else { return 0 }
    return numbers.map { number in
      ranges.contains(where: { $0.contains(number) }) ? 1 : 0
    }.reduce(0, +)
  }

  public func solvePart2() async throws -> Int {
    let sections = input.paragraphs
    guard
      let ranges = sections.first?.compactMap({ lines in
        let rangeNums = lines.split(separator: "-").compactMap({ Int($0) })
        return rangeNums[0]...rangeNums[1]
      })
    else { return 0 }
    var mutRanges = ranges.sorted(by: { $0.lowerBound < $1.lowerBound })
    var resultingRanges = [ClosedRange<Int>]()
    while !mutRanges.isEmpty {
      let nextRange = mutRanges.removeFirst()
      if let overlappingRangeIndex = resultingRanges.firstIndex(where: { $0.overlaps(nextRange) }) {
        let otherRange = resultingRanges[overlappingRangeIndex]
        resultingRanges[overlappingRangeIndex] = otherRange.merging(with: nextRange)
      } else {
        resultingRanges.append(nextRange)
      }
    }
    return resultingRanges.reduce(0) { $0 + $1.count }
  }
}
