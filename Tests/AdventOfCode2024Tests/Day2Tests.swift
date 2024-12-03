import AdventOfCode2024
import Testing

@Suite("Day 2") struct Day2Tests {
    @Test(
        "Part 1",
        arguments: [
            Solution(input: Day2.sample, output: 2),
            Solution(input: Day2.solution, output: 402),
        ]
    )
    func part1(_ solution: Solution) throws {
        let result = try Day2(input: solution.input).solvePart1()
        #expect(result == solution.output)
    }

    @Test func part2_test() throws {
        let result = try Day2(input: Day2.sample).solvePart2()
        #expect(result == 4)
    }

    @Test func part2_solution() throws {
        let result = try Day2(input: Day2.solution).solvePart2()
        #expect(result == 455)
    }
}
