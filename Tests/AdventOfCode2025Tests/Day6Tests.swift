import AdventOfCode2025
import Testing

@Suite("Day 6") struct Day6Tests {
  @Test func part1_test() async throws {
    let result = try await Day6(input: Day6.sample).solvePart1()
    #expect(result == 4_277_556)
  }

  @Test func part1_solution() async throws {
    let result = try await Day6().solvePart1()
    #expect(result == 6_172_481_852_142)
  }

  @Test func part2_test() async throws {
    let result = try await Day6(input: Day6.sample).solvePart2()
    #expect(result == 3_263_827)
  }

  @Test func part2_solution() async throws {
    let result = try await Day6().solvePart2()
    #expect(result == 10_188_206_723_429)
  }
}
