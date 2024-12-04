import AdventOfCode2024
import Testing

@Suite("Day 4") struct Day4Tests {
    @Test func part1_test() throws {
        let result = try Day4(input: Day4.sample).solvePart1()
        #expect(result == 18)
    }

    @Test func part1_solution() throws {
        let result = try Day4().solvePart1()
        #expect(result == 2613)
    }

    @Test func part2_test() throws {
        let result = try Day4(input: Day4.sample).solvePart2()
        #expect(result == 9)
    }

    @Test func part2_solution() throws {
        let result = try Day4().solvePart2()
        #expect(result == 1905)
    }
}
