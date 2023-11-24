// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PodCastPackage",
    platforms: [.iOS(.v13)],
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
    .package(url: "https://github.com/apple/swift-log.git", from: "1.2.0"),],
    
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "PodCastPackage",
        dependencies: ["NetworkHandling"]),
        
        .testTarget(
            name: "PodCastPackageTests",
            dependencies: ["PodCastPackage"]),
        
            .target(
                name: "NetworkHandling",
                dependencies: [
                    "AsyncCompatibilityKit",
                    .product(name: "Pulse", package: "Pulse"),
                    .product(name: "Logging", package: "swift-log"),
                    "Alamofire",
                ]
            )
    ]
)
