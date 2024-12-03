import AdventOfCodeKit
import RegexBuilder

public struct Day3 {
    public static let sample = """
        xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))
        """

    public static let sample2 = """
        xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))
        """

    public let input: String

    public init(
        input: String? = nil
    ) {
        let inputText =
            if let input {
                input
            } else if let input = try? Input.day(3) {
                input
            } else {
                Self.sample
            }
        self.input = inputText
    }

    struct Mul {
        let lhs: Int
        let rhs: Int

        var result: Int {
            lhs * rhs
        }
    }

    enum Instruction {
        case `do`  // swiftlint:disable:this identifier_name
        case dont
        case mul(Mul)
    }

    let mulRegex = Regex {
        "mul("
        Capture {
            OneOrMore(.digit)
        }
        ","
        Capture {
            OneOrMore(.digit)
        }
        ")"
    }

    public func solvePart1() throws -> Int {
        return input.matches(of: mulRegex).compactMap { match -> Int? in
            guard let lhs = Int(match.output.1), let rhs = Int(match.output.2) else { return nil }
            let mul = Mul(lhs: lhs, rhs: rhs)
            return mul.result
        }.reduce(0, +)
    }

    public func solvePart2() throws -> Int {
        let doDontRegex = Regex {
            Capture {
                ChoiceOf {
                    mulRegex
                    "do()"
                    "don't()"
                }
            }
        }
        let instructions = input.matches(of: doDontRegex).compactMap { match -> Instruction? in
            switch match.output.0 {
            case "do()":
                return .do
            case "don't()":
                return .dont
            default:
                guard let lhs = Int(match.output.2!), let rhs = Int(match.output.3!) else { return nil }
                let mul = Mul(lhs: lhs, rhs: rhs)
                return .mul(mul)
            }
        }

        var sum = 0
        var enabled = true
        for instruction in instructions {
            switch instruction {
            case .do:
                enabled = true
            case .dont:
                enabled = false
            case .mul(let mul):
                if enabled {
                    sum += mul.result
                }
            }
        }
        return sum
    }
}
