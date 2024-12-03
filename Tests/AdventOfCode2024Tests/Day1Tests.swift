import AdventOfCode2024
import Testing

@Suite("Day 1") struct Day1Tests {
    @Test func part1_test() throws {
        let result = try Day1(input: Day1.sample).solvePart1()
        #expect(result == 11)
    }

    @Test func part1_solution() throws {
        let result = try Day1().solvePart1()
        #expect(result == 2_166_959)
    }

    @Test func part2_test() throws {
        let result = try Day1(input: Day1.sample).solvePart2()
        #expect(result == 31)
    }

    @Test func part2_solution() throws {
        let result = try Day1().solvePart2()
        #expect(result == 23_741_109)
    }
}
