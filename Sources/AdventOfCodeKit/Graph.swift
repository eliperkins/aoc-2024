import DequeModule

public struct Graph<T> where T: Identifiable, T: Hashable {
    private let storage: [T.ID: T]
    private let map: [T.ID: [T.ID]]

    public init(
        items: [T], map: [T.ID: [T.ID]]
    ) {
        self.storage = Dictionary(uniqueKeysWithValues: zip(items.map(\.id), items))
        self.map = map
    }

    private struct BreadthFirstTraversalState {
        var visited: Set<T.ID>
        var deque: Deque<[T.ID]>
    }

    public func breadthFirstTraversal(from: T) -> AnySequence<[T]> {
        let initialState = BreadthFirstTraversalState(
            visited: Set([from.id]),
            deque: Deque([[from.id]])
        )
        return AnySequence(
            sequence(state: initialState) { state -> [T]? in
                if let path = state.deque.popFirst() {
                    guard let nodeID = path.last else { return nil }
                    for neighborID in map[nodeID, default: []] where !state.visited.contains(neighborID) {
                        let (inserted, _) = state.visited.insert(neighborID)
                        if inserted {
                            state.deque.append(path + [neighborID])
                        }
                    }
                    return path.compactMap { storage[$0] }
                }
                return nil
            })
    }

    public func breadthFirstSearch(from: T, to: T) -> [T] {
        for path in breadthFirstTraversal(from: from) {
            guard let position = path.last else { return [] }
            if position.id == to.id {
                return path
            }
        }

        return []
    }

    public struct PathResult: Hashable {
        public let source: T
        public let destination: T
        public let path: [T]

        public init(
            source: T, destination: T, path: [T]
        ) {
            self.source = source
            self.destination = destination
            self.path = path
        }
    }

    // swiftlint:disable:next cyclomatic_complexity function_body_length
    public func floydWarshall() -> Set<PathResult> {
        var dist = Matrix(repeating: Int.max, width: storage.keys.count, height: storage.keys.count)
        var next = Matrix(repeating: Int.max, width: storage.keys.count, height: storage.keys.count)

        let stableValues = Array(storage.keys.enumerated())
        let keyLookup = Dictionary(uniqueKeysWithValues: stableValues)
        let indexLookup = Dictionary(uniqueKeysWithValues: stableValues.map { ($1, $0) })

        // swiftlint:disable identifier_name
        for (i, neighbors) in map {
            for j in neighbors {
                if let x = indexLookup[i], let y = indexLookup[j] {
                    dist.set(value: 1, x: x, y: y)
                    next.set(value: y, x: x, y: y)
                } else {
                    fatalError()
                }
            }
        }

        // swiftlint:disable:next unused_enumerated
        for (index, _) in storage.keys.enumerated() {
            dist.set(value: 0, x: index, y: index)
            next.set(value: index, x: index, y: index)
        }

        // swiftlint:disable opening_brace
        for k in keyLookup.keys.sorted() {
            for i in keyLookup.keys.sorted() {
                for j in keyLookup.keys.sorted() {
                    if let edgeA = dist.atPosition(x: i, y: j),
                        let edgeB = dist.atPosition(x: i, y: k),
                        let edgeC = dist.atPosition(x: k, y: j)
                    {
                        if edgeB == .max || edgeC == .max {
                            continue
                        }

                        if edgeA > edgeB + edgeC {
                            dist.set(value: edgeB + edgeC, x: i, y: j)
                            next.set(value: next.atPosition(x: i, y: k)!, x: i, y: j)
                        }
                    }
                }
            }
        }
        // swiftlint:enable opening_brace

        var acc = [PathResult]()
        for u in keyLookup.keys.sorted() {
            for v in keyLookup.keys.sorted() {
                if u == v { continue }

                var path = [Int]()
                path.append(u)

                var pointer = u
                while pointer != v {
                    if let next = next.atPosition(x: pointer, y: v) {
                        pointer = next
                        path.append(next)
                    } else {
                        fatalError()
                    }
                }

                assert(path.first == u)
                assert(path.last == v)
                acc.append(
                    PathResult(
                        source: storage[keyLookup[u]!]!,
                        destination: storage[keyLookup[v]!]!,
                        path: path.compactMap { storage[keyLookup[$0]!]! }
                    )
                )
            }
        }
        // swiftlint:enable identifier_name

        return Set(acc)
    }
}
