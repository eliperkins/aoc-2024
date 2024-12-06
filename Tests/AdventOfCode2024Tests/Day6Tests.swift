import AdventOfCode2024
import Testing

@Suite("Day 6") struct Day6Tests {
    @Test func part1_test() throws {
        let result = try Day6(input: Day6.sample).solvePart1()
        #expect(result == 41)
    }

    @Test func part1_solution() throws {
        let result = try Day6().solvePart1()
        #expect(result == 5067)
    }

    @Test func part2_test() async throws {
        let result = try await Day6(input: Day6.sample).solvePart2()
        #expect(result == 6)
    }

    @Test func part2_solution() async throws {
        let result = try await Day6().solvePart2()
        #expect(result == 1793)
    }
}
