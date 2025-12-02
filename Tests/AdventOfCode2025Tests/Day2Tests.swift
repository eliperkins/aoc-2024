import AdventOfCode2025
import Testing

@Suite("Day 2") struct Day2Tests {
  @Test func part1_test() async throws {
    let result = try await Day2(input: Day2.sample).solvePart1()
    #expect(result == 1_227_775_554)
  }

  @Test func part1_solution() async throws {
    let result = try await Day2().solvePart1()
    #expect(result == 35_367_539_282)
  }

  @Test func part2_test() async throws {
    let result = try await Day2(input: Day2.sample).solvePart2()
    #expect(result == 4_174_379_265)
  }

  @Test func part2_solution() async throws {
    let result = try await Day2().solvePart2()
    #expect(result == 45_814_076_230)
  }
}
