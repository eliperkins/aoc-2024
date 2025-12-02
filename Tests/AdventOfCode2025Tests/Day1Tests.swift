import AdventOfCode2025
import Testing

@Suite("Day 1") struct Day1Tests {
  @Test func part1_test() async throws {
    let result = try await Day1(input: Day1.sample).solvePart1()
    #expect(result == 3)
  }

  @Test func part1_solution() async throws {
    let result = try await Day1().solvePart1()
    #expect(result == 1066)
  }

  @Test func part2_test() async throws {
    let result = try await Day1(input: Day1.sample).solvePart2()
    #expect(result == 6)
  }

  @Test func part2_solution() async throws {
    let result = try await Day1().solvePart2()
    #expect(result == 6223)
  }
}
