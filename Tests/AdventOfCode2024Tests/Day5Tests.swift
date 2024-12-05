import AdventOfCode2024
import Testing

@Suite("Day 5") struct Day5Tests {
    @Test func part1_test() throws {
        let result = try Day5(input: Day5.sample).solvePart1()
        #expect(result == 143)
    }

    @Test func part1_solution() throws {
        let result = try Day5().solvePart1()
        #expect(result == 5651)
    }

    @Test func part2_test() throws {
        let result = try Day5(input: Day5.sample).solvePart2()
        #expect(result == 123)
    }

    @Test func part2_solution() throws {
        let result = try Day5().solvePart2()
        #expect(result == 4743)
    }
}
