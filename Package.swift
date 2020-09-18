// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "NavigationRouter",
    platforms: [
        .iOS(.v9),
        .macOS(.v10_15)
    ],
    products: [
        .library(name: "NavigationRouter",
                 targets: ["NavigationRouter"])
    ],
    targets: [
        .target(
            name: "NavigationRouter",
            path: "Code"
        )
    ],
    swiftLanguageVersions: [.v5]
)
