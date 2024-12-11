import AdventOfCode2024
import Testing

@Suite("Day 11") struct Day11Tests {
    @Test func stoneInitializers() {
        let fullStone = Day11.Stone(intValue: 10, stringValue: "10")
        #expect(fullStone.intValue == 10)
        #expect(fullStone.stringValue == "10")

        let stringStone = Day11.Stone(stringValue: "10")
        #expect(stringStone.intValue == 10)
        #expect(stringStone.stringValue == "10")

        let intStone = Day11.Stone(intValue: 10)
        #expect(intStone.intValue == 10)
        #expect(intStone.stringValue == "10")

        let leadingZeroStone = Day11.Stone(stringValue: "010")
        #expect(leadingZeroStone.intValue == 10)
        #expect(leadingZeroStone.stringValue == "10")
    }

    @Test func part1_solution() async throws {
        var day = Day11()
        let result = try await day.solvePart1()
        #expect(result == 233875)
    }

    @Test func part2_solution() async throws {
        var day = Day11()
        let result = try await day.solvePart2()
        #expect(result == 277_444_936_413_293)
    }
}
