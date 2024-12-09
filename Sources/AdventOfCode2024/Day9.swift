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

    public func solvePart2() async throws -> Int {
        guard let diskMap = input.lines.first?.compactMap({ Int(String($0)) }) else {
            fatalError("Missing disk map!")
        }

        var fileRanges = OrderedSet<Range<Int>>()
        var freeSpaceRanges = OrderedSet<Range<Int>>()
        var blockMap = [Int: Range<Int>]()

        var pointer = 0
        for (i, id) in diskMap.enumerated() {
            let isFileID = i % 2 == 0
            if isFileID {
                let fileID = fileRanges.count
                let fileRange = pointer..<(pointer + id)
                blockMap[fileID] = fileRange
                fileRanges.append(fileRange)
            } else {
                freeSpaceRanges.append(pointer..<pointer + id)
            }
            pointer += id
        }

        for (index, fileRange) in fileRanges.enumerated().reversed() {
            let blockSize = fileRange.count
            if let matchingRange = freeSpaceRanges.first(where: {
                blockSize <= $0.count && $0.startIndex < fileRange.startIndex
            }) {
                let newFileRange = matchingRange.startIndex..<(matchingRange.startIndex + blockSize)
                blockMap[index] = newFileRange

                if matchingRange.count > blockSize {
                    let newRange = (matchingRange.startIndex + blockSize)..<matchingRange.endIndex
                    if let index = freeSpaceRanges.firstIndex(of: matchingRange) {
                        freeSpaceRanges.insert(newRange, at: index)
                        freeSpaceRanges.remove(matchingRange)
                    }
                } else {
                    freeSpaceRanges.remove(matchingRange)
                }

                if let insertionIndex = freeSpaceRanges.firstIndex(where: { $0.endIndex > fileRange.startIndex }) {
                    freeSpaceRanges.insert(fileRange, at: insertionIndex)
                }
            }
        }

        var result = 0
        for (fileID, range) in blockMap {
            for x in range {
                result += fileID * x
            }
        }
        return result
    }
}
