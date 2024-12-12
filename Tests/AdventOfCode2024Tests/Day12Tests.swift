import AdventOfCode2024
import Testing

@Suite("Day 12") struct Day12Tests {
    @Test func part1_test() async throws {
        let result = try await Day12(input: Day12.sample).solvePart1()
        #expect(result == 140)

        let result2 = try await Day12(input: Day12.noncontiguousSample).solvePart1()
        #expect(result2 == 772)

        let result3 = try await Day12(input: Day12.sample2).solvePart1()
        #expect(result3 == 1930)
    }

    @Test func part1_solution() async throws {
        let result = try await Day12().solvePart1()
        #expect(result == 1_374_934)
    }

    @Test func part2_test() async throws {
        let result = try await Day12(input: Day12.sample).solvePart2()
        #expect(result == 80)

        let result2 = try await Day12(input: Day12.noncontiguousSample).solvePart2()
        #expect(result2 == 436)

        let result3 = try await Day12(input: Day12.eSample).solvePart2()
        #expect(result3 == 236)

        let result4 = try await Day12(input: Day12.abSample).solvePart2()
        #expect(result4 == 368)
    }

    @Test func part2_solution() async throws {
        let result = try await Day12().solvePart2()
        #expect(result == 841078)
    }
}
