// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PodCastPackage",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "PodCastPackage",
            targets: ["PodCastPackage"]),
    ],
    dependencies: [        
        .package(
            url: "https://github.com/kean/Pulse.git",
            from: "2.1.2"
        ),
        .package(
            url: "https://github.com/JohnSundell/AsyncCompatibilityKit",
            from: "0.1.2"
        ),
        .package(
            url: "https://github.com/Alamofire/Alamofire.git",
            from: "5.4.4"
        ),
        .package(url: "https://github.com/apple/swift-log.git",
                 from: "1.2.0"
        ),
        .package(
            url: "https://github.com/kishikawakatsumi/KeychainAccess.git",
            from: "4.2.2"
        ),
        .package(
            url: "https://github.com/auth0/JWTDecode.swift.git",
            from: "3.0.0"
        ),
        .package(url: "https://github.com/siteline/swiftui-introspect", from: "1.0.0"
        ),
        .package(url: "https://github.com/onevcat/Kingfisher.git",
                 from: "7.6.2"),
        .package(
            url: "https://github.com/airbnb/lottie-ios.git",
            from: "4.2.0"
        )
    ],
    
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "PodCastPackage",
            dependencies: ["AppFlow",
                           .product(name: "Lottie", package: "lottie-ios")]),
        
            .testTarget(
                name: "PodCastPackageTests",
                dependencies: ["PodCastPackage"],
                resources: [.process("Resources")]),
        
            .target(
                name: "NetworkHandling",
                dependencies: [
                    "AsyncCompatibilityKit",
                    .product(name: "Pulse", package: "Pulse"),
                    .product(name: "Logging", package: "swift-log"),
                    "Alamofire",
                    "KeychainAccess",
                    .product(name: "JWTDecode", package: "JWTDecode.swift"),
                ]
            ),
        
        .target(
                name: "UI",
        dependencies: [
            .product(name: "SwiftUIIntrospect", package: "swiftui-introspect"),
            .product(name: "Kingfisher", package: "Kingfisher"),
            .product(name: "Lottie", package: "lottie-ios")
        ],
        resources: [.process("Resources")]),
        
        
        .target(
            name: "AppFlow",
        dependencies: ["NetworkHandling",
                       "UI"]),
        
    ]
)
