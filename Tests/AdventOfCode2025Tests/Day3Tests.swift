import AdventOfCode2025
import Testing

@Suite("Day 3") struct Day3Tests {
  @Test func part1_test() async throws {
    let result = try await Day3(input: Day3.sample).solvePart1()
    #expect(result == 357)
  }

  @Test func part1_solution() async throws {
    let result = try await Day3().solvePart1()
    #expect(result == 17493)
  }

  @Test func part2_test() async throws {
    let result = try await Day3(input: Day3.sample).solvePart2()
    #expect(result == 3_121_910_778_619)
  }

  @Test func part2_solution() async throws {
    let result = try await Day3().solvePart2()
    #expect(result == 173_685_428_989_126)
  }
}
