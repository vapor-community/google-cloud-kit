// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "google-cloud-kit",
    platforms: [
        .macOS(.v13),
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "GoogleCloudKit",
            targets: [
                "Core",
                "Datastore",
                "IAMServiceAccountCredentials",
                "PubSub",
                "SecretManager",
                "Storage",
            ]
        ),
        .library(
            name: "GoogleCloudCore",
            targets: ["Core"]
        ),
        .library(
            name: "GoogleCloudStorage",
            targets: ["Storage"]
        ),
        .library(
            name: "GoogleCloudDatastore",
            targets: ["Datastore"]
        ),
        .library(
            name: "GoogleCloudSecretManager",
            targets: ["SecretManager"]
        ),
        .library(
            name: "GoogleCloudIAMServiceAccountCredentials",
            targets: ["IAMServiceAccountCredentials"]
        ),
        .library(
            name: "GoogleCloudTranslation",
            targets: ["Translation"]
        ),
        .library(
            name: "GoogleCloudPubSub",
            targets: ["PubSub"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.18.0"),
        .package(url: "https://github.com/vapor/jwt-kit.git", from: "5.0.0-beta.1")
    ],
    targets: [
        .target(
            name: "Core",
            dependencies: [
                .product(name: "JWTKit", package: "jwt-kit"),
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
            ],
            path: "Core/Sources/"
        ),
        .target(
            name: "Storage",
            dependencies: [
                .target(name: "Core")
            ],
            path: "Storage/Sources/"
        ),
        .target(
            name: "Datastore",
            dependencies: [
                .target(name: "Core")
            ],
            path: "Datastore/Sources/"
        ),
        .target(
            name: "SecretManager",
            dependencies: [
                .target(name: "Core")
            ],
            path: "SecretManager/Sources"
        ),
        .target(
            name: "IAMServiceAccountCredentials",
            dependencies: [
                .target(name: "Core")
            ],
            path: "IAMServiceAccountCredentials/Sources"
        ),
        .target(
            name: "Translation",
            dependencies: [
                .target(name: "Core")
            ],
            path: "Translation/Sources"
        ),
        .target(
            name: "PubSub",
            dependencies: [
                .target(name: "Core")
            ],
            path: "PubSub/Sources/"
        ),
        .testTarget(
            name: "CoreTests",
            dependencies: [
                .target(name: "Core"),
                .product(name: "AsyncHTTPClient", package: "async-http-client")
            ],
            path: "Core/Tests/"
        ),
        .testTarget(
            name: "StorageTests",
            dependencies: [
                .target(name: "Storage")
            ],
            path: "Storage/Tests/"
        ),
        .testTarget(
            name: "DatastoreTests",
            dependencies: [
                .target(name: "Datastore")
            ],
            path: "Datastore/Tests/"
        ),
        .testTarget(
            name: "TranslationTests",
            dependencies: [
                .target(name: "Translation")
            ],
            path: "Translation/Tests/"
        ),
        .testTarget(
            name: "PubSubTests",
            dependencies: [
                .target(name: "PubSub")
            ],
            path: "PubSub/Tests/"
        ),
    ]
)
