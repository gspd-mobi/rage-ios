// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "Rage",
    products: [
        .library(name: "Rage", targets: ["Rage"]),
        .library(name: "RxRage", targets: ["RxRage"])
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "5.0.0"))
    ],
    targets: [
        .target(
            name: "Rage",
            dependencies: [],
            exclude: [
                "Tests",
                "Sources/Supporting Files",
                "Examples"]),
        .target(
            name: "RxRage",
            dependencies: [
                "Rage",
                "RxSwift"],
            exclude: [
                "Tests",
                "Sources/Supporting Files",
                "Examples"])
    ],
    swiftLanguageVersions: [5]
)
