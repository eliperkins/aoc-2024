// swift-tools-version: 6.0

import PackageDescription

var products: [Product] = [
    .library(name: "AdventOfCode2024", targets: ["AdventOfCode2024"]),
    .library(name: "AdventOfCodeKit", targets: ["AdventOfCodeKit"]),
]
var targets: [Target] = [
    .target(
        name: "AdventOfCode2024",
        dependencies: [
            .product(name: "Algorithms", package: "swift-algorithms"),
            .product(name: "Collections", package: "swift-collections"),
            .product(name: "Numerics", package: "swift-numerics"),
            .target(name: "AdventOfCodeKit"),
        ],
        resources: [
            .copy("Inputs")
        ],
        cSettings: [
            .define("ACCELERATE_NEW_LAPACK"),
            .define("ACCELERATE_LAPACK_ILP64"),
        ],
        swiftSettings: [
            .unsafeFlags([
                "-O",
                "-cross-module-optimization",
            ])
        ]
    ),
    .target(
        name: "AdventOfCodeKit",
        dependencies: [
            .product(name: "Algorithms", package: "swift-algorithms"),
            .product(name: "Collections", package: "swift-collections"),
            .product(name: "DequeModule", package: "swift-collections"),
        ]
    ),
    .testTarget(
        name: "AdventOfCode2024Tests",
        dependencies: ["AdventOfCode2024"]
    ),
    .testTarget(
        name: "AdventOfCodeKitTests",
        dependencies: ["AdventOfCodeKit"]
    ),
]
var dependencies: [Package.Dependency] = [
    .package(url: "https://github.com/apple/swift-algorithms", from: "1.2.1"),
    .package(url: "https://github.com/apple/swift-collections", from: "1.2.1"),
    .package(url: "https://github.com/apple/swift-numerics", from: "1.0.3"),
]
#if os(macOS) || os(Linux)
    products.append(.executable(name: "aoc-cli", targets: ["AdventOfCodeCLI"]))
    targets.append(
        .executableTarget(
            name: "AdventOfCodeCLI",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        ))
    dependencies.append(
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.5.0"))
#endif

let package = Package(
    name: "AdventOfCode2024",
    platforms: [.macOS(.v15)],
    products: products,
    dependencies: dependencies,
    targets: targets
)
