import AdventOfCode2025
import Testing

@Suite("Day 11") struct Day11Tests {
  @Test func part1_test() async throws {
    let result = try await Day11(input: Day11.sample).solvePart1()
    #expect(result == 5)
  }

  @Test func part1_solution() async throws {
    let result = try await Day11().solvePart1()
    #expect(result == 683)
  }

  @Test(.disabled("Unimplemented")) func part2_test() async throws {
    let result = try await Day11(input: Day11.sample2).solvePart2()
    #expect(result == 2)
  }

  @Test(.disabled("Unimplemented")) func part2_solution() async throws {
    let result = try await Day11().solvePart2()
    #expect(result == 1)
  }
}
