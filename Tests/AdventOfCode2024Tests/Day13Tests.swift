#if canImport(Accelerate)
    import AdventOfCode2024
    import Testing

    @Suite("Day 13") struct Day13Tests {
        @Test func part1_test() async throws {
            let result = try await Day13(input: Day13.sample).solvePart1()
            #expect(result == 480)
        }

        @Test func part1_solution() async throws {
            let result = try await Day13().solvePart1()
            #expect(result == 28262)
        }

        @Test func part2_test() async throws {
            let result = try await Day13(input: Day13.sample).solvePart2()
            #expect(result == 875_318_608_908)
        }

        @Test func part2_solution() async throws {
            let result = try await Day13().solvePart2()
            #expect(result == 101_406_661_266_314)
        }
    }
#endif
