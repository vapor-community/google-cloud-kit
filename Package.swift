// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "GoogleCloudKit",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "GoogleCloudKit",
            targets: ["GoogleCloudKit"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.0.0"),
        .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.0.0-alpha.1"),
        .package(url: "https://github.com/vapor/jwt-kit.git", from: "4.0.0-alpha")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "GoogleCloudKit",
            dependencies: ["AsyncHTTPClient", "JWTKit", "NIOFoundationCompat"]),
        .testTarget(
            name: "GoogleCloudKitTests",
            dependencies: ["GoogleCloudKit", "AsyncHTTPClient"]),
    ]
)
