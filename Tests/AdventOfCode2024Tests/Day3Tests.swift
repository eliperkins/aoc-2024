import AdventOfCode2024
import Testing

@Suite("Day 3") struct Day3Tests {
    @Test func part1_test() throws {
        let result = try Day3(input: Day3.sample).solvePart1()
        #expect(result == 161)
    }

    @Test func part1_solution() throws {
        let result = try Day3().solvePart1()
        #expect(result == 160_672_468)
    }

    @Test func part2_test() throws {
        let result = try Day3(input: Day3.sample2).solvePart2()
        #expect(result == 48)
    }

    @Test func part2_solution() throws {
        let result = try Day3().solvePart2()
        #expect(result == 84_893_551)
    }
}
