import AdventOfCodeKit

public struct Day7: Sendable {
    public static let sample = """
    190: 10 19
    3267: 81 40 27
    83: 17 5
    156: 15 6
    7290: 6 8 6 15
    161011: 16 10 13
    192: 17 8 14
    21037: 9 7 18 13
    292: 11 6 16 20
    """

    public let input: String
    let calibrations: [Calibration]

    public init(
        input: String? = nil
    ) {
        let inputText =
            if let input {
                input
            } else if let input = try? Input.day(7) {
                input
            } else {
                Self.sample
            }
        self.input = inputText
        self.calibrations = inputText.lines.map { line in
            let sides = line.split(separator: ":")
            guard let lhs = sides.first.flatMap(String.init).flatMap(Int.init),
                  let rhs = sides.last.flatMap(String.init) else { fatalError() }
            
            let components = rhs.split(separator: " ").compactMap {
                Int(String($0))
            }
            return Calibration(result: lhs, values: components)
        }
    }
    
    struct Calibration: Sendable {
        let result: Int
        let values: [Int]
        
        func evaluate(lhs: Int, rhs: Int) -> (Int, Int) {
            return (lhs + rhs, lhs * rhs)
        }
        
        func evaluateConcat(lhs: Int, rhs: Int) -> (Int, Int, Int) {
            return (lhs + rhs, lhs * rhs, Int("\(lhs)\(rhs)")!)
        }

        func evaluate() -> Bool {
            evaluate(values, matching: result)
        }
        
        func evaluateConcat() -> Bool {
            evaluateConcat(values, matching: result)
        }
        
        // MARK: - Recursive funcs
        
        private func evaluate(_ values: [Int], matching: Int) -> Bool {
            if values.count == 2, let lhs = values.first, let rhs = values.last {
                let (addResult, multResult) = evaluate(lhs: lhs, rhs: rhs)
                return addResult == matching || multResult == matching
            } else if values.count > 2 {
                let firstTwo = values.prefix(2)
                let rest = values.dropFirst(2)
                if let lhs = firstTwo.first, let rhs = firstTwo.last {
                    let (addResult, multResult) = evaluate(lhs: lhs, rhs: rhs)
                    return evaluate([addResult] + rest, matching: matching) || evaluate([multResult] + rest, matching: matching)
                }
            }
            
            fatalError("Invalid number of digits!")
        }
        
        private func evaluateConcat(_ values: [Int], matching: Int) -> Bool {
            if values.count == 2, let lhs = values.first, let rhs = values.last {
                let (addResult, multResult, concatResult) = evaluateConcat(lhs: lhs, rhs: rhs)
                return addResult == matching || multResult == matching || concatResult == matching
            } else if values.count > 2 {
                let firstTwo = values.prefix(2)
                let rest = values.dropFirst(2)
                if let lhs = firstTwo.first, let rhs = firstTwo.last {
                    let (addResult, multResult, concatResult) = evaluateConcat(lhs: lhs, rhs: rhs)
                    return evaluateConcat([addResult] + rest, matching: matching)
                        || evaluateConcat([multResult] + rest, matching: matching)
                        || evaluateConcat([concatResult] + rest, matching: matching)
                }
            }
            
            fatalError("Invalid number of digits!")
        }
    }

    public func solvePart1() async throws -> Int {
        return calibrations.filter { $0.evaluate() }
            .map(\.result)
            .reduce(0, +)
    }

    public func solvePart2() async throws -> Int {
        return calibrations.filter { $0.evaluateConcat() }
            .map(\.result)
            .reduce(0, +)
    }
}
