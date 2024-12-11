import AdventOfCodeKit

public struct Day11: Sendable {
    public static let sample = """
        0 1 10 99 999
        """
    public static let sample2 = """
        125 17
        """

    public let input: String
    public let initialStones: [Stone]
    public var stones: [Stone]

    public init(
        input: String? = nil
    ) {
        let inputText =
            if let input {
                input
            } else if let input = try? Input.day(11) {
                input
            } else {
                Self.sample
            }
        self.input = inputText
        let stones = inputText.split(separator: " ").map {
            Stone(stringValue: String($0))
        }
        self.initialStones = stones
        self.stones = stones
    }

    public struct Stone: Sendable, Hashable {
        public let intValue: Int
        public let stringValue: String

        public init(stringValue: String) {
            self.stringValue = String(
                stringValue.trimmingPrefix(while: { char in
                    char == "0"
                }))
            self.intValue = Int(stringValue)!
        }

        public init(intValue: Int) {
            self.stringValue = String(intValue)
            self.intValue = intValue
        }

        public init(intValue: Int, stringValue: String) {
            self.intValue = intValue
            self.stringValue = String(
                stringValue.trimmingPrefix(while: { char in
                    char == "0"
                }))
        }

        public func splitting() -> (Stone, Stone)? {
            if stringValue.count.isMultiple(of: 2) {
                let halfwayPoint = stringValue.index(stringValue.startIndex, offsetBy: stringValue.count / 2)
                let lhs = String(stringValue[stringValue.startIndex..<halfwayPoint])
                let rhs = String(stringValue[halfwayPoint...])
                return (Stone(stringValue: lhs), Stone(stringValue: rhs))
            }

            return nil
        }
    }

    actor MemoizingIntCache {
        struct CacheKey: Hashable {
            let intValue: Int
            let times: Int
        }
        var cache = [CacheKey: Int]()

        func set(key: CacheKey, value: Int) {
            cache[key] = value
        }

        func get(key: CacheKey) -> Int? {
            cache[key]
        }
    }

    let memoizingIntCache = MemoizingIntCache()

    func solve(_ stone: Stone, times: Int) async -> Int {
        let cacheKey = MemoizingIntCache.CacheKey(
            intValue: stone.intValue,
            times: times
        )

        if let solution = await memoizingIntCache.get(key: cacheKey) {
            return solution
        }

        if times == 0 {
            return 1
        }

        if stone.intValue == 0 {
            return await solve(Stone(intValue: 1), times: times - 1)
        }

        if let (lhs, rhs) = stone.splitting() {
            return await solve(lhs, times: times - 1) + solve(rhs, times: times - 1)
        }

        let result = await solve(Stone(intValue: stone.intValue * 2024), times: times - 1)
        await memoizingIntCache.set(key: cacheKey, value: result)
        return result
    }

    public mutating func solvePart1() async throws -> Int {
        var result = 0
        for stone in stones {
            result += await solve(stone, times: 25)
        }
        return result
    }

    public mutating func solvePart2() async throws -> Int {
        var result = 0
        for stone in stones {
            result += await solve(stone, times: 75)
        }
        return result
    }
}
