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
        .library(name: "Async Semaphore", targets: ["Async Semaphore"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-atoms/swift-async.git", branch: "main"),
        .package(url: "https://github.com/swift-molecules/swift-async-waiter.git", branch: "main"),
        .package(url: "https://github.com/swift-molecules/swift-buffer-ring.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-either.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-memory.git", branch: "main"),
        .package(url: "https://github.com/swift-molecules/swift-memory-allocation.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-queue.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-storage.git", branch: "main", traits: ["Generational", "Memory"]),
    ],
    targets: [
        .target(
            name: "Async Semaphore",
            dependencies: [
                .product(name: "Async Continuation", package: "swift-async"),
                .product(name: "Async Lifecycle", package: "swift-async"),
                .product(name: "Async Mutex", package: "swift-async"),
                .product(name: "Async Precedence", package: "swift-async"),
                .product(name: "Async Primitive", package: "swift-async"),
                .product(name: "Async Promise", package: "swift-async"),
                .product(name: "Async Waiter", package: "swift-async-waiter"),
                .product(name: "Buffer Ring Primitive", package: "swift-buffer-ring"),
                .product(name: "Either", package: "swift-either"),
                .product(name: "Memory", package: "swift-memory"),
                .product(name: "Memory Allocator", package: "swift-memory-allocation"),
                .product(name: "Queue", package: "swift-queue"),
                .product(name: "Queue Primitive", package: "swift-queue"),
                .product(name: "Storage", package: "swift-storage"),
            ],
            path: "Sources/Async Semaphore"
        ),
        .testTarget(
            name: "Async Semaphore Tests",
            dependencies: [
                .product(name: "Async", package: "swift-async"),
                .target(name: "Async Semaphore"),
            ],
            path: "Tests/Async Semaphore Tests"
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
