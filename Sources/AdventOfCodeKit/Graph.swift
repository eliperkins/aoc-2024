import Collections
import DequeModule

public struct Graph<T>: @unchecked Sendable where T: Identifiable, T: Hashable {
    private let storage: [T.ID: T]
    private let map: [T.ID: [T.ID]]

    public init(
        items: [T],
        map: [T.ID: [T.ID]]
    ) {
        self.storage = Dictionary(uniqueKeysWithValues: zip(items.map(\.id), items))
        self.map = map
    }

    private func neighbors(of node: T) -> [T] {
        if let neighborIDs = map[node.id] {
            return neighborIDs.compactMap { storage[$0] }
        }
        return []
    }

    private func neighbors(of nodeID: T.ID) -> [T] {
        if let neighborIDs = map[nodeID] {
            return neighborIDs.compactMap { storage[$0] }
        }
        return []
    }

    private func neighborIDs(of node: T) -> [T.ID] {
        map[node.id] ?? []
    }

    private func neighborIDs(of nodeID: T.ID) -> [T.ID] {
        map[nodeID] ?? []
    }

    private struct BreadthFirstTraversalState {
        @usableFromInline
        var visited: Set<T.ID>

        @usableFromInline
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
                    for neighborID in neighborIDs(of: nodeID) where !state.visited.contains(neighborID) {
                        let (inserted, _) = state.visited.insert(neighborID)
                        if inserted {
                            state.deque.append(path + [neighborID])
                        }
                    }
                    return path.compactMap { storage[$0] }
                }
                return nil
            }
        )
    }

    public func breadthFirstSearch(from: T, to: T) -> [T] {
        for path in breadthFirstTraversal(from: from).lazy {
            guard let position = path.last else { return [] }
            if position.id == to.id {
                return path
            }
        }

        return []
    }

    public func depthFirstTraversal(from: T) -> [T] {
        var path = OrderedSet<T.ID>()
        var stack = Deque([from.id])
        while let nodeID = stack.popFirst() {
            path.append(nodeID)
            let nextNodes = neighborIDs(of: nodeID)
            for node in nextNodes where !path.contains(node) {
                stack.prepend(node)
            }
        }
        return path.compactMap { storage[$0] }
    }

    public func depthFirstSearch(from: T, to: T) -> [T] {
        var visited = Set<T.ID>()
        var stack = Deque<[T]>()

        stack.append([from])

        while let path = stack.popLast() {
            let node = path.last!

            if visited.contains(node.id) {
                continue
            }

            visited.insert(node.id)

            if node.id == to.id {
                return path
            }

            for neighbor in neighbors(of: node) where !visited.contains(neighbor.id) {
                var newPath = path
                newPath.append(neighbor)
                stack.prepend(newPath)
            }
        }

        return []
    }

    public func findAllPaths(from: T, to: T) -> [[T]] {
        var result = [[T]]()
        var stack = Deque<([T.ID], Set<T.ID>)>()

        stack.append(([from.id], [from.id]))

        while let (pathIDs, visited) = stack.popLast() {
            let currentID = pathIDs.last!

            if currentID == to.id {
                let path = pathIDs.compactMap { storage[$0] }
                result.append(path)
                continue
            }

            for neighborID in neighborIDs(of: currentID) where !visited.contains(neighborID) {
                var newPathIDs = pathIDs
                newPathIDs.append(neighborID)
                var newVisited = visited
                newVisited.insert(neighborID)
                stack.prepend((newPathIDs, newVisited))
            }
        }

        return result
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
