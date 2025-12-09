import AdventOfCodeKit
import Foundation
import simd

public struct Day8: Sendable {
  public static let sample = """
    162,817,812
    57,618,57
    906,360,560
    592,479,940
    352,342,300
    466,668,158
    542,29,236
    431,825,988
    739,650,466
    52,470,668
    216,146,977
    819,987,18
    117,168,530
    805,96,715
    346,949,466
    970,615,88
    941,993,340
    862,61,35
    984,92,344
    425,690,689
    """

  public let input: String

  public init(
    input: String? = nil
  ) {
    let inputText =
      if let input {
        input
      } else if let input = try? Input.day(8) {
        input
      } else {
        Self.sample
      }
    self.input = inputText
  }

  typealias Node = SIMD3<Double>
  struct Edge: Hashable {
    let a: SIMD3<Double>
    let b: SIMD3<Double>
  }
  public func solvePart1(connectionCount: Int) async throws -> Int {
    let xs = input.lines.map { line in
      let parts = line.split(separator: ",").compactMap { Double($0) }
      return SIMD3<Double>(parts)
    }

    let sorted =
      xs
      .combinations(ofCount: 2)
      .sorted(by: { lhs, rhs in
        simd.distance(lhs[0], lhs[1]) < simd.distance(rhs[0], rhs[1])
      })
      .prefix(connectionCount)

    var circuits: [UUID: Set<Node>] = [:]
    for pair in sorted {
      let a = pair[0]
      let b = pair[1]
      let existingCircuits = circuits.filter { $0.value.contains(a) || $0.value.contains(b) }
      if existingCircuits.isEmpty {
        circuits[UUID()] = [a, b]
      } else {
        for existingCircuit in existingCircuits {
          circuits.removeValue(forKey: existingCircuit.key)
        }
        var newCircuit: Set<Node> = [a, b]
        newCircuit.formUnion(existingCircuits.flatMap(\.value))
        circuits[UUID()] = newCircuit
      }
    }

    return
      circuits.values
      .map(\.count)
      .sorted()
      .reversed()
      .prefix(3)
      .reduce(1, *)
  }

  public func solvePart2() async throws -> Int {
    let xs = input.lines.map { line in
      let parts = line.split(separator: ",").compactMap { Double($0) }
      return SIMD3<Double>(parts)
    }

    var sorted =
      xs
      .combinations(ofCount: 2)
      .sorted(by: { lhs, rhs in
        simd.distance(lhs[0], lhs[1]) > simd.distance(rhs[0], rhs[1])
      })

    var circuits: [UUID: Set<Node>] = [:]
    var lastConnection: [Node] = []
    while circuits.values.map(\.count).sum() != xs.count, let next = sorted.popLast() {
      lastConnection = next
      let a = next[0]
      let b = next[1]
      let existingCircuits = circuits.filter { $0.value.contains(a) || $0.value.contains(b) }
      if existingCircuits.isEmpty {
        circuits[UUID()] = [a, b]
      } else {
        for existingCircuit in existingCircuits {
          circuits.removeValue(forKey: existingCircuit.key)
        }
        var newCircuit: Set<Node> = [a, b]
        newCircuit.formUnion(existingCircuits.flatMap(\.value))
        circuits[UUID()] = newCircuit
      }
    }

    return Int(lastConnection[0].x * lastConnection[1].x)
  }
}
