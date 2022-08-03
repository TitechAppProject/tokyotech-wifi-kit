// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TokyoTechWifiKit",
    platforms: [
        .macOS(.v12),
        .iOS(.v15),
        .watchOS(.v8),
        .tvOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "TokyoTechWifiKit",
            targets: ["TokyoTechWifiKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/tid-kijyun/Kanna.git", from: "5.2.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "TokyoTechWifiKit",
            dependencies: ["Kanna"]),
        .testTarget(
            name: "TokyoTechWifiKitTests",
            dependencies: ["TokyoTechWifiKit"],
            resources: [
                .process("HTML"),
            ]),
    ]
)
