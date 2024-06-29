// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "Liquid",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Liquid",
            targets: ["Liquid"]
        ),
        .executable(
            name: "LiquidClient",
            targets: ["LiquidClient"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", from: "600.0.0-latest"),
        .package(url: "https://github.com/vapor/vapor.git", from: "4.102.0"),
        .package(url: "https://github.com/pointfreeco/swift-macro-testing.git", branch: "main"),
    ],
    targets: [
        .target(name: "Liquid", dependencies: [
            .target(name: "LiquidMacros"),
            .product(name: "Vapor", package: "vapor")
        ]),


        .macro(
            name: "LiquidMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),

        .executableTarget(name: "LiquidClient", dependencies: ["Liquid"]),

        .testTarget(
            name: "LiquidMacroTests",
            dependencies: [
                "LiquidMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
                .product(name: "MacroTesting", package: "swift-macro-testing"),
            ]
        ),
    ]
)
