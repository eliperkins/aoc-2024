import AdventOfCode2025
import Testing

@Suite("Day 5") struct Day5Tests {
  @Test func part1_test() async throws {
    let result = try await Day5(input: Day5.sample).solvePart1()
    #expect(result == 3)
  }

  @Test func part1_solution() async throws {
    let result = try await Day5().solvePart1()
    #expect(result == 840)
  }

  @Test func part2_test() async throws {
    let result = try await Day5(input: Day5.sample).solvePart2()
    #expect(result == 14)
  }

  @Test func part2_solution() async throws {
    let result = try await Day5().solvePart2()
    #expect(result == 359_913_027_576_322)
  }
}
