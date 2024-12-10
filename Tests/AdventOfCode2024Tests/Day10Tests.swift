import AdventOfCode2024
import Testing

@Suite("Day 10") struct Day10Tests {
    @Test func part1_test() async throws {
        let score2 = try await Day10(input: Day10.sampleScore2).solvePart1()
        #expect(score2 == 2)
        let score4 = try await Day10(input: Day10.sampleScore4).solvePart1()
        #expect(score4 == 4)
        let score3 = try await Day10(input: Day10.sampleScore3).solvePart1()
        #expect(score3 == 3)
        let score36 = try await Day10(input: Day10.sampleScore36).solvePart1()
        #expect(score36 == 36)
    }

    @Test func part1_solution() async throws {
        let result = try await Day10().solvePart1()
        #expect(result == 667)
    }

    @Test func part2_test() async throws {
        let rating3 = try await Day10(input: Day10.sampleRating3).solvePart2()
        #expect(rating3 == 3)
        let rating13 = try await Day10(input: Day10.sampleRating13).solvePart2()
        #expect(rating13 == 13)
        let rating227 = try await Day10(input: Day10.sampleRating227).solvePart2()
        #expect(rating227 == 227)
        let rating81 = try await Day10(input: Day10.sampleRating81).solvePart2()
        #expect(rating81 == 81)
    }

    @Test func part2_solution() async throws {
        let result = try await Day10().solvePart2()
        #expect(result == 1344)
    }
}
