// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "ValueX",
    platforms: [.iOS(.v9)],
    products: [
        .library(name: "ValueXObjC", targets: ["ValueXObjC"]),
        .library(name: "ValueXSwift", targets: ["ValueXSwift"])
    ],
    targets: [
        .target(
            name: "ValueXObjC"
        ),
        .target(
            name: "ValueXSwift"
        )
    ],
    
    swiftLanguageVersions: [.v5]
)

