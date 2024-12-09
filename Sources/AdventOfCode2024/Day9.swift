import AdventOfCodeKit
import Collections

public struct Day9: Sendable {
    public static let sample = """
        2333133121414131402
        """

    public let input: String

    public init(
        input: String? = nil
    ) {
        let inputText =
            if let input {
                input
            } else if let input = try? Input.day(9) {
                input
            } else {
                Self.sample
            }
        self.input = inputText
    }

    public func solvePart1() async throws -> Int {
        guard let diskMap = input.lines.first?.compactMap({ Int(String($0)) }) else {
            fatalError("Missing disk map!")
        }

        let blockCount = diskMap.reduce(0, +)
        var fileIDs = [Int]()
        var freeSpaceRanges = [Range<Int>]()
        var blocks = [Int?](repeating: nil, count: blockCount)

        var pointer = 0
        for (i, id) in diskMap.enumerated() {
            let isFileID = i % 2 == 0

            if isFileID {
                for index in pointer..<(pointer + id) {
                    blocks[index] = fileIDs.count
                }
                fileIDs.append(id)
            } else {
                freeSpaceRanges.append(pointer..<pointer + id)
            }

            pointer += id
        }

        let fileIDCount = fileIDs.reduce(0, +)
        var toCompact = blocks[fileIDCount...].compactMap({ $0 })
        func compact(_ xs: inout [Int?], range: Range<Int>) {
            var toInsert = toCompact.suffix(range.count)
            toCompact = toCompact.dropLast(range.count)
            for x in range {
                if let inserting = toInsert.popLast() {
                    xs[x] = inserting
                }
            }
        }

        var rangePointer = 0
        for range in freeSpaceRanges where rangePointer < fileIDCount {
            compact(&blocks, range: range)
            rangePointer = range.endIndex
        }

        func fileID(at index: Int) -> Int {
            blocks[index] ?? 0
        }

        func checksum(_ blocks: [Int]) -> Int {
            blocks.enumerated().reduce(0) { acc, next in
                let (index, value) = next
                return acc + index * value
            }
        }

        let compacted = (0..<fileIDCount).map(fileID(at:))
        return checksum(compacted)
    }

    struct Block: Hashable {
        enum StorageType: Hashable {
            case file(Int)
            case freeSpace
        }
        let type: StorageType
        let location: Int
        let size: Int

        var id: Int {
            switch self.type {
            case .file(let id): id
            case .freeSpace: Int.max
            }
        }

        var range: Range<Int> {
            location..<(location + size)
        }

        var checksum: Int {
            switch type {
            case .file(let id):
                return range.reduce(0) { acc, next in
                    acc + (next * id)
                }
            case .freeSpace:
                return 0
            }
        }
    }

    func createBlocks(_ diskMap: [Int]) -> ([Block], [Block]) {
        var id = 0
        var location = 0
        var fileBlocks = [Block]()
        var freeSpaceBlocks = [Block]()
        for (i, length) in diskMap.enumerated() {
            let isFileBlock = i % 2 == 0
            if isFileBlock {
                fileBlocks.append(Block(type: .file(id), location: location, size: length))
                id += 1
            } else {
                freeSpaceBlocks.append(Block(type: .freeSpace, location: location, size: length))
            }
            location += length
        }
        return (fileBlocks, freeSpaceBlocks)
    }

    public func solvePart2() async throws -> Int {
        guard let diskMap = input.lines.first?.compactMap({ Int(String($0)) }) else {
            fatalError("Missing disk map!")
        }

        let (fileBlocks, freeSpace) = createBlocks(diskMap)
        var freeSpaceBySize = Dictionary(grouping: freeSpace, by: { element in element.size }).mapValues(Set.init)

        func takeFirstFreeSpace(forFile file: Block, size: Int) -> Block? {
            if let firstFreeSpace = (size..<10)
                .flatMap({ bucket in freeSpaceBySize[bucket, default: []] })
                .filter({ $0.location < file.location })
                .sorted(by: { lhs, rhs in lhs.location < rhs.location })
                .first
            {
                var freeSpaces = freeSpaceBySize[firstFreeSpace.size, default: []]
                freeSpaces.remove(firstFreeSpace)
                freeSpaceBySize[firstFreeSpace.size] = freeSpaces

                if firstFreeSpace.size > file.size {
                    let newBlock = Block(
                        type: .freeSpace, location: firstFreeSpace.location + file.size,
                        size: firstFreeSpace.size - file.size)
                    var newFreeSpaces = freeSpaceBySize[newBlock.size, default: []]
                    newFreeSpaces.insert(newBlock)
                    freeSpaceBySize[newBlock.size] = newFreeSpaces
                }

                return firstFreeSpace
            }

            return nil
        }

        var result = 0
        for fileBlock in fileBlocks.reversed() {
            if let freeSpace = takeFirstFreeSpace(forFile: fileBlock, size: fileBlock.size) {
                let block = Block(type: .file(fileBlock.id), location: freeSpace.location, size: fileBlock.size)
                result += block.checksum
            } else {
                result += fileBlock.checksum
            }
        }
        return result
    }
}
