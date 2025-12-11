// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ProdactKit",
    platforms: [
        .iOS(.v13),
        .tvOS(.v11),
        .macOS(.v10_13),
        .watchOS(.v4),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "ProdactKit",
            targets: ["ProdactKit"]),
        .library(
            name: "AmplitudeAnalyticsWrapper",
            targets: ["AmplitudeAnalyticsWrapper"]),
        .library(
            name: "AppMetricaAnalyticsWrapper",
            targets: ["AppMetricaAnalyticsWrapper"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/amplitude/Amplitude-iOS.git", exact: "8.14.0"),
        .package(url: "https://github.com/appmetrica/appmetrica-sdk-ios", from: "5.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "ProdactKit",
            dependencies: []),
        .target(
            name: "AmplitudeAnalyticsWrapper",
            dependencies: [
                "ProdactKit",
                .product(name: "Amplitude", package: "Amplitude-iOS")
            ]),
        .target(
            name: "AppMetricaAnalyticsWrapper",
            dependencies: [
                "ProdactKit",
                .product(name: "AppMetricaCore", package: "appmetrica-sdk-ios")
            ]),
        .testTarget(
            name: "ProdactKitTests",
            dependencies: ["ProdactKit"]),
        
    ]
)
