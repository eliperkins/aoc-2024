import AdventOfCodeKit

public struct Day5 {
    public static let sample = """
        47|53
        97|13
        97|61
        97|47
        75|29
        61|13
        75|53
        29|13
        97|29
        53|29
        61|53
        97|53
        61|29
        47|13
        75|47
        97|75
        47|61
        75|61
        47|29
        75|13
        53|13

        75,47,61,53,29
        97,61,53,29,13
        75,29,13
        75,97,47,61,53
        61,13,29
        97,13,75,29,47
        """

    public let input: String
    let rules: [PageOrderRule]
    let updates: [Update]

    public init(
        input: String? = nil
    ) {
        let inputText =
            if let input {
                input
            } else if let input = try? Input.day(5) {
                input
            } else {
                Self.sample
            }
        self.input = inputText

        let xs = inputText.split(separator: "\n\n")
        guard
            let rules = xs.first.flatMap(String.init)?.lines.compactMap({
                let parts = $0.split(separator: "|")
                if let lhs = parts.first.flatMap(String.init).flatMap(Int.init),
                    let rhs = parts.last.flatMap(String.init).flatMap(Int.init)
                {
                    return PageOrderRule(lhs: lhs, rhs: rhs)
                }
                return nil
            }),
            let updates = xs.last.flatMap(String.init)?.lines.map({
                let nums = $0.split(separator: ",").compactMap {
                    Int(String($0))
                }
                return Update(pageNumbers: nums)
            })
        else { fatalError() }

        self.rules = rules
        self.updates = updates
    }

    struct PageOrderRule {
        let lhs: Int
        let rhs: Int
    }

    struct Update {
        let pageNumbers: [Int]
        let index: [Int: [Int].Index]
        var mid: Int {
            pageNumbers[pageNumbers.count / 2]
        }

        init(pageNumbers: [Int]) {
            self.pageNumbers = pageNumbers
            var index = [Int: [Int].Index]()
            for (i, page) in pageNumbers.enumerated() {
                index[page] = i
            }
            self.index = index
        }

        func passes(rule: PageOrderRule) -> Bool {
            if let lhsIndex = index[rule.lhs], let rhsIndex = index[rule.rhs] {
                return lhsIndex < rhsIndex
            }
            return true
        }

        func passes(rules: [PageOrderRule]) -> Bool {
            rules.allSatisfy(passes(rule:))
        }

        func applying(rule: PageOrderRule) -> Update {
            if !passes(rule: rule) {
                var newPageNumbers = pageNumbers
                if let lhsIndex = index[rule.lhs], let rhsIndex = index[rule.rhs] {
                    newPageNumbers.remove(at: rhsIndex)
                    newPageNumbers.insert(rule.rhs, at: lhsIndex)
                }
                return Update(pageNumbers: newPageNumbers)
            }

            return self
        }

        func applying(rules: [PageOrderRule]) -> Update {
            var mut = self
            while !mut.passes(rules: rules) {
                mut = rules.reduce(mut) { acc, next in
                    acc.applying(rule: next)
                }
            }
            return mut
        }
    }

    public func solvePart1() throws -> Int {
        updates.reduce(0) { acc, next in
            let passes = next.passes(rules: rules)
            if passes {
                return acc + next.mid
            }
            return acc
        }
    }

    public func solvePart2() throws -> Int {
        updates.reduce(0) { acc, next in
            if next.passes(rules: rules) {
                return acc
            }

            return acc + next.applying(rules: rules).mid
        }
    }
}
