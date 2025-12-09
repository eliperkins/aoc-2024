import AdventOfCode2025
import Testing

@Suite("Day 8") struct Day8Tests {
  @Test func part1_test() async throws {
    let result = try await Day8(input: Day8.sample).solvePart1(connectionCount: 10)
    #expect(result == 40)
  }

  @Test func part1_solution() async throws {
    let result = try await Day8().solvePart1(connectionCount: 1000)
    #expect(result == 90036)
  }

  @Test func part2_test() async throws {
    let result = try await Day8(input: Day8.sample).solvePart2()
    #expect(result == 25272)
  }

  @Test func part2_solution() async throws {
    let result = try await Day8().solvePart2()
    #expect(result == 1)
  }
}
