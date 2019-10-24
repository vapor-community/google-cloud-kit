// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "GoogleCloudKit",
    products: [
         .library(
             name: "GoogleCloudCore",
             targets: ["Core"]
         ),
         .library(
             name: "GoogleCloudStorage",
             targets: ["Storage"]
         ),
        .library(
            name: "GoogleCloudKit",
            targets: ["Core", "Storage"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.0.0"),
        .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.0.0-alpha.1"),
        .package(url: "https://github.com/vapor/jwt-kit.git", from: "4.0.0-alpha")
    ],
    targets: [
        .target(
            name: "Core",
            dependencies: ["AsyncHTTPClient", "JWTKit", "NIOFoundationCompat"],
            path: "Core/Sources/"
        ),
        .target(
            name: "Storage",
            dependencies: ["Core"],
            path: "Storage/Sources/"
        ),
        .testTarget(
            name: "CoreTests",
            dependencies: ["Core", "AsyncHTTPClient"],
            path: "Core/Tests/"
        ),
        .testTarget(
            name: "StorageTests",
            dependencies: ["Storage"],
            path: "Storage/Tests/"
        ),
    ]
)
