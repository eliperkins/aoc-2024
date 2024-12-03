import ArgumentParser

@main
struct Main: AsyncParsableCommand {
    @OptionGroup var options: Options

    static let configuration = CommandConfiguration(
        abstract: "Fetches the input data for the current day",
        subcommands: [Make.self, Fetch.self, Test.self],
        defaultSubcommand: Make.self
    )
}
