import AdventOfCodeKit

public struct Day2: Sendable {

  // swiftlint:disable line_length
  public static let sample = """
    11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124
    """
  // swiftlint:enable line_length

  public let input: String

  public init(input: String? = nil) {
    let inputText =
      if let input {
        input
      } else if let input = try? Input.day(2) {
        input
      } else {
        Self.sample
      }
    self.input = inputText
  }

  public func solvePart1() async throws -> Int {
    let ranges: [ClosedRange<Int>] = input.split(separator: ",").compactMap { rangeText in
      let rangeParts = rangeText.split(separator: "-")
      guard let start = Int(rangeParts[0]), let end = Int(rangeParts[1]) else {
        return nil
      }
      return start...end
    }

    func invalidIDSum(in range: ClosedRange<Int>) -> Int {
      range.reduce(0) { acc, next in
        let stringValue = String(next)
        let splitPoint = stringValue.index(
          stringValue.startIndex,
          offsetBy: Int(stringValue.count / 2)
        )
        if stringValue.count % 2 == 0 {
          let lhs = stringValue[..<splitPoint]
          let rhs = stringValue[splitPoint...]
          if lhs == rhs {
            return acc + next
          } else {
            return acc
          }
        } else {
          return acc
        }
      }
    }

    return ranges.reduce(0) { acc, next in
      acc + invalidIDSum(in: next)
    }
  }

  public func solvePart2() async throws -> Int {
    let ranges: [ClosedRange<Int>] = input.split(separator: ",").compactMap { rangeText in
      let rangeParts = rangeText.split(separator: "-")
      guard let start = Int(rangeParts[0]), let end = Int(rangeParts[1]) else {
        return nil
      }
      return start...end
    }

    func invalidIDSum(in range: ClosedRange<Int>) -> Int {
      range.reduce(0) { acc, next in
        let stringValue = String(next)
        if stringValue.count < 2 {
          return acc
        }

        let mid = Int(stringValue.count / 2)
        for i in (1...mid) where stringValue.count % i == 0 {
          let chunks = stringValue.chunks(ofCount: i)
          guard let first = chunks.first else {
            continue
          }
          let match = chunks.allSatisfy({ $0 == first })
          if match {
            return acc + next
          }
        }
        return acc
      }
    }

    return ranges.reduce(0) { acc, next in
      acc + invalidIDSum(in: next)
    }
  }
}
