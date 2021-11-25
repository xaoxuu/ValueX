// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "ValueX",
    platforms: [.iOS(.v9)],
    products: [
        .library(name: "ValueX", targets: ["ValueX"])
    ],
    targets: [
        .target(
            name: "ValueX",
            path: "ValueX"
        )
    ],
    
    swiftLanguageVersions: [.v5]
)

