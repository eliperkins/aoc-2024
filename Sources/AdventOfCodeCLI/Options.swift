import ArgumentParser
import Foundation

struct Options: ParsableArguments {
    static let calendar: Calendar = Calendar(identifier: .gregorian)

    @Option(name: [.long, .customShort("d")], help: "The Advent of Code day.")
    var day: Int = {
        let today = calendar.dateComponents([.day], from: Date())
        return today.day!
    }()

    @Option(name: [.long, .customShort("y")], help: "The Advent of Code year.")
    var year: Int = {
        let today = calendar.dateComponents([.year], from: Date())
        return today.year!
    }()
}
