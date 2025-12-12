import AdventOfCode2025
import Testing

@Suite("Day 9") struct Day9Tests {
  @Test func part1_test() async throws {
    let result = try await Day9(input: Day9.sample).solvePart1()
    #expect(result == 50)
  }

  @Test func part1_solution() async throws {
    let result = try await Day9().solvePart1()
    #expect(result == 4_754_955_192)
  }

  @Test(.disabled("Unimplemented")) func part2_test() async throws {
    let result = try await Day9(input: Day9.sample).solvePart2()
    #expect(result == 1)
  }

  @Test(.disabled("Unimplemented")) func part2_solution() async throws {
    let result = try await Day9().solvePart2()
    #expect(result == 1)
  }
}
