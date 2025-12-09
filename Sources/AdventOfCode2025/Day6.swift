import AdventOfCodeKit
import Foundation

public struct Day6: Sendable {
  public static let sample = #"""
    123 328  51 64
     45 64  387 23
      6 98  215 314
    *   +   *   +
    """#

  public let input: String

  public init(
    input: String? = nil
  ) {
    let inputText =
      if let input {
        input
      } else if let input = try? Input.day(6) {
        input
      } else {
        Self.sample
      }
    self.input = inputText
  }

  public func solvePart1() async throws -> Int {
    var lines = input.lines
    let lastRow = lines.removeLast().filter { $0 == "+" || $0 == "*" }
    let values = Matrix<Int>(
      rows: lines.map { line in
        line.split(separator: " ")
          .compactMap({ chunk in
            if chunk.isEmpty {
              return nil
            }
            return Int(chunk)
          })
      })

    return lastRow.enumerated().reduce(0) { acc, next in
      let operation = next.element
      switch operation {
      case "+":
        return acc + values.columns[next.offset].reduce(0, +)
      case "*":
        return acc + values.columns[next.offset].reduce(1, *)
      default:
        fatalError("Invalid operation! \(operation)")
      }
    }
  }

  public func solvePart2() async throws -> Int {
    let maxLineLength = input.lines.map(\.count).max() ?? 0
    var rows = input.lines.map { line in
      Array(line.padding(toLength: maxLineLength, withPad: " ", startingAt: 0))
    }
    let operations = rows.removeLast().filter { $0 == "+" || $0 == "*" }
    let matrix = Matrix(rows: rows)

    let chunks = matrix.columns.split {
      $0.allSatisfy(\.isWhitespace)
    }.map { chunks in
      chunks.compactMap { chunk in
        Int(String(chunk).trimmingCharacters(in: .whitespacesAndNewlines))
      }
    }
    return zip(chunks, operations).reduce(0) { acc, next in
      let (chunk, operation) = next
      switch operation {
      case "+":
        return acc + chunk.reduce(0, +)
      case "*":
        return acc + chunk.reduce(1, *)
      default:
        fatalError("Invalid operation! \(operation)")
      }
    }
  }
}
