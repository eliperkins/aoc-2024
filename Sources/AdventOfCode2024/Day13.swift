#if canImport(Accelerate)
    import Accelerate
    import AdventOfCodeKit
    import RegexBuilder

    public struct Day13: Sendable {
        public static let sample = """
            Button A: X+94, Y+34
            Button B: X+22, Y+67
            Prize: X=8400, Y=5400

            Button A: X+26, Y+66
            Button B: X+67, Y+21
            Prize: X=12748, Y=12176

            Button A: X+17, Y+86
            Button B: X+84, Y+37
            Prize: X=7870, Y=6450

            Button A: X+69, Y+23
            Button B: X+27, Y+71
            Prize: X=18641, Y=10279
            """

        public let input: String

        public init(
            input: String? = nil
        ) {
            let inputText =
                if let input {
                    input
                } else if let input = try? Input.day(13) {
                    input
                } else {
                    Self.sample
                }
            self.input = inputText
        }

        struct Machine {
            let buttonA: Point
            let buttonB: Point
            let prize: Point

            var leastAmountOfTokens: Int? {
                var matches = [Int]()
                for aPresses in 0...100 {
                    for bPresses in 0...100 {
                        let xLocation = (aPresses * buttonA.x) + (bPresses * buttonB.x)
                        let yLocation = (aPresses * buttonA.y) + (bPresses * buttonB.y)
                        let location = Point(x: xLocation, y: yLocation)
                        if location == prize {
                            matches.append(
                                (aPresses * 3) + bPresses
                            )
                        }
                    }
                }
                return matches.min()
            }

            var accelerateTokens: Int? {
                let aValues = [
                    buttonA.x, buttonA.y,
                    buttonB.x, buttonB.y,
                ].map(Double.init)

                let bValues = [
                    prize.x,
                    prize.y,
                ].map(Double.init)

                let x = nonsymmetric_general(
                    a: aValues,
                    dimension: 2,
                    b: bValues,
                    rightHandSideCount: 1
                )

                if let x, x.count == 2 {
                    let a = Int(x[0].rounded())
                    let b = Int(x[1].rounded())
                    let position = Point(
                        x: (a * buttonA.x) + (b * buttonB.x),
                        y: (a * buttonA.y) + (b * buttonB.y)
                    )
                    if position == prize {
                        return (a * 3) + b
                    }
                }

                return nil
            }
        }

        static func parse(_ input: String, paddingPrize: Int = 0) -> [Machine] {
            let buttonARegex = Regex {
                "Button A: X+"
                Capture {
                    OneOrMore(.digit)
                }
                ", Y+"
                Capture {
                    OneOrMore(.digit)
                }
            }

            let buttonBRegex = Regex {
                "Button B: X+"
                Capture {
                    OneOrMore(.digit)
                }
                ", Y+"
                Capture {
                    OneOrMore(.digit)
                }
            }

            let prizeRegex = Regex {
                "Prize: X="
                Capture {
                    OneOrMore(.digit)
                }
                ", Y="
                Capture {
                    OneOrMore(.digit)
                }
            }

            return input.paragraphs.compactMap { paragraph -> Machine? in
                let lines = paragraph.filter { !$0.isEmpty }

                let buttonALine = lines[0]
                let buttonBLine = lines[1]
                let prizeLine = lines[2]

                if let buttonA = buttonALine.wholeMatch(of: buttonARegex),
                    let buttonB = buttonBLine.wholeMatch(of: buttonBRegex),
                    let prize = prizeLine.wholeMatch(of: prizeRegex)
                {
                    return Machine(
                        buttonA: Point(x: Int(buttonA.output.1)!, y: Int(buttonA.output.2)!),
                        buttonB: Point(x: Int(buttonB.output.1)!, y: Int(buttonB.output.2)!),
                        prize: Point(x: Int(prize.output.1)! + paddingPrize, y: Int(prize.output.2)! + paddingPrize)
                    )
                }
                return nil
            }
        }

        public func solvePart1() async throws -> Int {
            let machines = Self.parse(input)
            return machines.reduce(0) { acc, next in
                if let tokens = next.accelerateTokens {
                    return acc + tokens
                }
                return acc
            }
        }

        public func solvePart2() async throws -> Int {
            let machines = Self.parse(input, paddingPrize: 10_000_000_000_000)
            return machines.reduce(0) { acc, next in
                if let tokens = next.accelerateTokens {
                    return acc + tokens
                }
                return acc
            }
        }
    }

    /// Returns the _x_ in _Ax = b_ for a nonsquare coefficient matrix using `sgesv_`.
    ///
    /// - Parameter a: The matrix _A_ in _Ax = b_ that contains `dimension * dimension`
    /// elements.
    /// - Parameter dimension: The order of matrix _A_.
    /// - Parameter b: The matrix _b_ in _Ax = b_ that contains `dimension * rightHandSideCount`
    /// elements.
    /// - Parameter rightHandSideCount: The number of columns in _b_.
    ///
    /// The function specifies the leading dimension (the increment between successive columns of a matrix)
    /// of matrices as their number of rows.

    /// - Tag: nonsymmetric_general
    func nonsymmetric_general(
        a: [Double],
        dimension: Int,
        b: [Double],
        rightHandSideCount: Int
    ) -> [Double]? {

        var info: __LAPACK_int = 0

        /// Create a mutable copy of the right hand side matrix _b_ that the
        /// function returns as the solution matrix _x_.
        var x = b

        /// Create a mutable copy of `a` to pass to the LAPACK routine. The routine
        /// overwrites `mutableA` with the factors `L` and `U` from
        /// the factorization `A = P * L * U`.
        var mutableA = a

        var ipiv = [__LAPACK_int](repeating: 0, count: dimension)

        /// Call `sgesv_` to compute the solution.
        withUnsafePointer(to: __LAPACK_int(dimension)) { dim in
            withUnsafePointer(to: __LAPACK_int(rightHandSideCount)) { nrhs in
                dgesv_(
                    dim,
                    nrhs,
                    &mutableA,
                    dim,
                    &ipiv,
                    &x,
                    dim,
                    &info)
            }
        }

        if info != 0 {
            NSLog("nonsymmetric_general error \(info)")
            return nil
        }
        return x
    }
#endif
