import ArgumentParser
import Foundation

#if os(Linux)
    import FoundationNetworking
#endif

struct Fetch: AsyncParsableCommand {
    static let configuration: CommandConfiguration = CommandConfiguration(
        abstract: "Fetches the input for the given day."
    )

    @OptionGroup var options: Options

    func run() async throws {
        guard let token = ProcessInfo.processInfo.environment["AOC_SESSION"] else {
            throw ValidationError("AOC_SESSION environment variable not set.")
        }

        let cookieStorage = HTTPCookieStorage.shared
        cookieStorage.setCookie(
            HTTPCookie(
                properties: [
                    .domain: ".adventofcode.com",
                    .path: "/",
                    .name: "session",
                    .value: token,
                ]
            )!
        )
        let url = URL(
            string: "https://adventofcode.com/\(options.year)/day/\(options.day)/input"
        )!
        let session = URLSession(configuration: .default)
        #if canImport(FoundationNetworking)
            let data = try await withCheckedThrowingContinuation { continuation in
                let task = session.dataTask(with: url) { data, _, error in
                    if let data {
                        continuation.resume(returning: data)
                    } else if let error {
                        continuation.resume(throwing: error)
                    }
                }
                task.resume()
            }
        #else
            let (data, _) = try await session.data(from: url)
        #endif
        guard let input = String(data: data, encoding: .utf8) else {
            throw ValidationError("Could not decode input data.")
        }

        let fileManager = FileManager.default
        let currentDirectory = fileManager.currentDirectoryPath
        let inputDirectory = URL(fileURLWithPath: currentDirectory)
            .appendingPathComponent("Sources/AdventOfCode\(options.year)/Inputs")
        try fileManager.createDirectory(
            at: inputDirectory,
            withIntermediateDirectories: true,
            attributes: nil
        )
        let inputPath = inputDirectory.appendingPathComponent("day\(options.day).txt")
        try input.write(to: inputPath, atomically: true, encoding: .utf8)
    }
}
