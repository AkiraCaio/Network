// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Network",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "Network",
            targets: ["Network"]),
        .library(
            name: "NetworkTestSources",
            targets: ["NetworkTestSources"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Network",
            dependencies: []),
        .target(
            name: "NetworkTestSources",
            dependencies: [
                "Network"
            ]),
        .testTarget(
            name: "NetworkTests",
            dependencies: [
                "Network",
                "NetworkTestSources"
            ]),
    ]
)
