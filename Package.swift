// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "Rage",
    products: [
        .library(name: "Rage", targets: ["Rage"]),
        .library(name: "RxRage", targets: ["RxRage"])
    ],
    dependencies: [
        .package(url: "https://github.com/antitypical/Result.git", .upToNextMajor(from: "3.2.4")),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "4.1.2"))
    ],
    targets: [
        .target(
            name: "Rage",
            dependencies: [
                "Result"],
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
    swiftLanguageVersions: [4]
)
