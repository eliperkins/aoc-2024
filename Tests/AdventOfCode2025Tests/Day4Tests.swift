import AdventOfCode2025
import Testing

@Suite("Day 4") struct Day4Tests {
  @Test func part1_test() async throws {
    let result = try await Day4(input: Day4.sample).solvePart1()
    #expect(result == 13)
  }

  @Test func part1_solution() async throws {
    let result = try await Day4().solvePart1()
    #expect(result == 1564)
  }

  @Test func part2_test() async throws {
    let result = try await Day4(input: Day4.sample).solvePart2()
    #expect(result == 43)
  }

  @Test func part2_solution() async throws {
    let result = try await Day4().solvePart2()
    #expect(result == 9401)
  }
}
