import AdventOfCode2024
import Testing

@Suite("Day 7") struct Day7Tests {
    @Test func part1_test() async throws {
        let result = try await Day7(input: Day7.sample).solvePart1()
        #expect(result == 3749)
    }

    @Test func part1_solution() async throws {
        let result = try await Day7().solvePart1()
        #expect(result == 3_598_800_864_292)
    }

    @Test func part2_test() async throws {
        let result = try await Day7(input: Day7.sample).solvePart2()
        #expect(result == 11387)
    }

    @Test func part2_solution() async throws {
        let result = try await Day7().solvePart2()
        #expect(result == 340_362_529_351_427)
    }
}
