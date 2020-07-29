// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "progress",
    products: [
        .executable(name: "progress", targets: ["progress"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-tools-support-core.git", from: "0.1.10"),
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "0.2.0"),
    ],
    targets: [
        .target(
            name: "progress",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "SwiftToolsSupport", package: "swift-tools-support-core")
            ]),
        .testTarget(
            name: "progressTests",
            dependencies: ["progress"]),
    ]
)
