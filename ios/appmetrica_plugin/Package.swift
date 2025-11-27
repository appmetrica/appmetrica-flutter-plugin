// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "appmetrica_plugin",
    platforms: [
        .iOS("13.0"),
    ],
    products: [
        .library(name: "appmetrica-plugin", targets: ["appmetrica_plugin"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/appmetrica/appmetrica-sdk-ios",
            from: "5.15.0"
        ),
    ],
    targets: [
        .target(
            name: "appmetrica_plugin",
            dependencies: [
                .product(name: "AppMetricaAdSupport", package: "appmetrica-sdk-ios"),
                .product(name: "AppMetricaCore", package: "appmetrica-sdk-ios"),
                .product(name: "AppMetricaCrashes", package: "appmetrica-sdk-ios"),
                .product(name: "AppMetricaLibraryAdapter", package: "appmetrica-sdk-ios"),
                .product(name: "AppMetricaWebKit", package: "appmetrica-sdk-ios"),
            ],
            resources: [],
            cSettings: [
                .headerSearchPath("include/appmetrica_plugin"),
            ]
        ),
    ]
)
