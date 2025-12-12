import AdventOfCodeKit

public struct Day11: Sendable {
  public static let sample = """
    aaa: you hhh
    you: bbb ccc
    bbb: ddd eee
    ccc: ddd eee fff
    ddd: ggg
    eee: out
    fff: out
    ggg: out
    hhh: ccc fff iii
    iii: out
    """

  public static let sample2 = """
    svr: aaa bbb
    aaa: fft
    fft: ccc
    bbb: tty
    tty: ccc
    ccc: ddd eee
    ddd: hub
    hub: fff
    eee: dac
    dac: fff
    fff: ggg hhh
    ggg: out
    hhh: out
    """

  public let input: String

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
  }

  public func solvePart1() async throws -> Int {
    let keyValues = input.lines.map { line in
      let source = String(line.prefix(3))
      let destinations = line.dropFirst(5).split(separator: " ").map(String.init)
      return (source, destinations)
    }
    let map = Dictionary(uniqueKeysWithValues: keyValues)
    let items = Array(Set(map.keys + map.values.flatMap { $0 }))
    let graph = Graph(items: items, map: map)
    return graph.findAllPaths(from: "you", to: "out").count
  }

  public func solvePart2() async throws -> Int {
    let keyValues = input.lines.map { line in
      let source = String(line.prefix(3))
      let destinations = line.dropFirst(5).split(separator: " ").map(String.init)
      return (source, destinations)
    }
    let map = Dictionary(uniqueKeysWithValues: keyValues)
    let items = Array(Set(map.keys + map.values.flatMap { $0 }))
    let graph = Graph(items: items, map: map)

    return await withTaskGroup { outerGroup in
      outerGroup.addTask {
        await withTaskGroup { innerGroup in
          innerGroup.addTask {
            graph.findAllPaths(from: "svr", to: "fft").count
          }
          innerGroup.addTask {
            graph.findAllPaths(from: "fft", to: "dac").count
          }
          innerGroup.addTask {
            graph.findAllPaths(from: "dac", to: "out").count
          }

          return await innerGroup.reduce(into: 1) { $0 *= $1 }
        }
      }

      outerGroup.addTask {
        await withTaskGroup { innerGroup in
          innerGroup.addTask {
            graph.findAllPaths(from: "svr", to: "dac").count
          }
          innerGroup.addTask {
            graph.findAllPaths(from: "dac", to: "fft").count
          }
          innerGroup.addTask {
            graph.findAllPaths(from: "fft", to: "out").count
          }

          return await innerGroup.reduce(into: 1) { $0 *= $1 }
        }
      }

      return await outerGroup.reduce(into: 0) { $0 += $1 }
    }
  }
}

extension String: @retroactive Identifiable {
  public var id: String {
    self
  }
}
