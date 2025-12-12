import AdventOfCode2025
import Testing

@Suite("Day 10") struct Day10Tests {
  @Test func part1_test() async throws {
    let result = try await Day10(input: Day10.sample).solvePart1()
    #expect(result == 7)
  }

  @Test func part1_solution() async throws {
    let result = try await Day10().solvePart1()
    #expect(result == 422)
  }

  @Test(.disabled("Unimplemented")) func part2_test() async throws {
    let result = try await Day10(input: Day10.sample).solvePart2()
    #expect(result == 33)
  }

  @Test(.disabled("Unimplemented")) func part2_solution() async throws {
    let result = try await Day10().solvePart2()
    #expect(result == 1)
  }
}
