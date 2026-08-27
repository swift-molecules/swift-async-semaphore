// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-async-semaphore",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(
            name: "Async Semaphore",
            targets: ["Async Semaphore"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/swift-molecules/swift-async.git", branch: "main"),
        .package(url: "https://github.com/swift-molecules/swift-async-waiter.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-either.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-queue.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "Async Semaphore",
            dependencies: [
                .product(name: "Async", package: "swift-async"),
                .product(name: "Async Waiter", package: "swift-async-waiter"),
                .product(name: "Either", package: "swift-either"),
                .product(name: "Queue", package: "swift-queue"),
            ]
        ),
        .testTarget(
            name: "Async Semaphore Tests",
            dependencies: [
                "Async Semaphore",
                .product(name: "Async", package: "swift-async"),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]

    let package: [SwiftSetting] = [
        .enableExperimentalFeature("RawLayout")
    ]

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
