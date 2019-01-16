// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "Onigmo",
    products: [
        .library(name: "Onigmo", targets: ["Onigmo"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "Onigmo", dependencies: []),
        .testTarget(name: "OnigmoTests", dependencies: ["Onigmo"])
    ]
)
