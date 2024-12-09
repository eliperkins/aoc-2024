import AdventOfCode2024
import Testing

@Suite("Day 8") struct Day8Tests {
    @Test func part1_test() async throws {
        let result = try await Day8(input: Day8.sample).solvePart1()
        #expect(result == 14)
    }

    @Test func part1_solution() async throws {
        let result = try await Day8().solvePart1()
        #expect(result == 222)
    }

    @Test func part2_test() async throws {
        let result = try await Day8(input: Day8.sample).solvePart2()
        #expect(result == 34)
    }

    @Test func part2_solution() async throws {
        let result = try await Day8().solvePart2()
        #expect(result == 884)
    }
}
