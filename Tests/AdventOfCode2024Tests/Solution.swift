import AdventOfCodeKit
import Testing

struct Solution: CustomTestStringConvertible, CustomTestArgumentEncodable {
    let input: SolutionInput
    let output: Int

    var testDescription: String {
        input.id + " == \(output)"
    }

    func encodeTestArgument(to encoder: some Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(input.id)
    }
}
