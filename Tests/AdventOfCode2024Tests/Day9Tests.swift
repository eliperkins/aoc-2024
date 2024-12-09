import AdventOfCode2024
import Testing

@Suite("Day 9") struct Day9Tests {
    @Test func part1_test() async throws {
        let result = try await Day9(input: Day9.sample).solvePart1()
        #expect(result == 1928)
    }

    @Test func part1_solution() async throws {
        let result = try await Day9().solvePart1()
        #expect(result == 6_461_289_671_426)
    }

    @Test func part2_test() async throws {
        let result = try await Day9(input: Day9.sample).solvePart2()
        #expect(result == 2858)
    }

    @Test func part2_solution() async throws {
        let result = try await Day9().solvePart2()
        #expect(result == 6_488_291_456_470)
    }
}
