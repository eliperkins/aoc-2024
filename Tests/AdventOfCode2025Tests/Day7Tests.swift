import AdventOfCode2025
import Testing

@Suite("Day 7") struct Day7Tests {
  @Test func part1_test() async throws {
    let result = try await Day7(input: Day7.sample).solvePart1()
    #expect(result == 21)
  }

  @Test func part1_solution() async throws {
    let result = try await Day7().solvePart1()
    #expect(result == 1638)
  }

  @Test func part2_test() async throws {
    let result = try await Day7(input: Day7.sample).solvePart2()
    #expect(result == 40)
  }

  @Test func part2_solution() async throws {
    let result = try await Day7().solvePart2()
    #expect(result == 7_759_107_121_385)
  }
}
