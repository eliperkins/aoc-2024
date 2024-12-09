import ArgumentParser
import Foundation

struct Make: AsyncParsableCommand {
    @OptionGroup var options: Options

    static let configuration: CommandConfiguration = CommandConfiguration(
        abstract: "Bootstraps the workspace and solution for the given day."
    )

    private func sourceFile(_ day: Int) -> String {
        """
        import AdventOfCodeKit

        public struct Day\(options.day): Sendable {
            public static let sample = \"\"\"
            \"\"\"

            public let input: String

            public init(
                input: String? = nil
            ) {
                let inputText =
                    if let input {
                        input
                    } else if let input = try? Input.day(\(options.day)) {
                        input
                    } else {
                        Self.sample
                    }
                self.input = inputText
            }

            public func solvePart1() async throws -> Int {
                0
            }

            public func solvePart2() async throws -> Int {
                0
            }
        }
        """
    }

    private func testFile(_ day: Int) -> String {
        """
        import AdventOfCode\(options.year)
        import Testing

        @Suite("Day \(options.day)") struct Day\(options.day)Tests {
            @Test func part1_test() async throws {
                let result = try await Day\(options.day)(input: Day\(options.day).sample).solvePart1()
                #expect(result == 1)
            }

            @Test func part1_solution() async throws {
                let result = try await Day\(options.day)().solvePart1()
                #expect(result == 1)
            }

            @Test func part2_test() async throws {
                let result = try await Day\(options.day)(input: Day\(options.day).sample).solvePart2()
                #expect(result == 1)
            }

            @Test func part2_solution() async throws {
                let result = try await Day\(options.day)().solvePart2()
                #expect(result == 1)
            }
        }
        """
    }

    func run() async throws {
        let fileManager = FileManager.default
        let currentDirectory = fileManager.currentDirectoryPath
        let sourceDirectory = URL(fileURLWithPath: currentDirectory)
            .appendingPathComponent("Sources/AdventOfCode\(options.year)")
        try fileManager.createDirectory(
            at: sourceDirectory,
            withIntermediateDirectories: true,
            attributes: nil
        )
        let sourcePath = sourceDirectory.appendingPathComponent("Day\(options.day).swift")
        try sourceFile(options.day).write(to: sourcePath, atomically: true, encoding: .utf8)

        let testDirectory = URL(fileURLWithPath: currentDirectory)
            .appendingPathComponent("Tests/AdventOfCode\(options.year)Tests")
        try fileManager.createDirectory(
            at: testDirectory,
            withIntermediateDirectories: true,
            attributes: nil
        )
        let testPath = testDirectory.appendingPathComponent("Day\(options.day)Tests.swift")
        try testFile(options.day).write(to: testPath, atomically: true, encoding: .utf8)

        try await Fetch.parse().run()
    }
}
