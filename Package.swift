// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftToGraph",
    platforms: [.macOS(.v10_15)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SwiftToGraph",
            targets: ["SwiftToGraph"]),
        .executable(
            name: "SwiftToGraphExample",
            targets: ["SwiftToGraphExample"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
//        .package(url: "https://github.com/apple/swift-syntax.git", branch: "0.50700.1")
        .package(url: "https://github.com/apple/swift-syntax.git", branch: "0.50700.1"),
        .package(url: "https://github.com/Umar-M-Haroon/GraphKit", branch: "main"),
        .package(url: "https://github.com/apple/swift-collections.git", .upToNextMinor(from: "1.0.4")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .executableTarget(
            name: "SwiftToGraphExample",
            dependencies: [
                .target(name: "SwiftToGraph"),
            ]
        ),
        .target(
            name: "SwiftToGraph",
            dependencies: [
                .product(name: "GraphKit", package: "GraphKit"),
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxParser", package: "swift-syntax"),
                .product(name: "Collections", package: "swift-collections")
            ]),
        .testTarget(
            name: "SwiftToGraphTests",
            dependencies: ["SwiftToGraph"]),
    ]
)
