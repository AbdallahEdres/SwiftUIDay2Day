// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "SwiftUIDay2Day",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "SwiftUIDay2Day",
            targets: ["SwiftUIDay2Day"]),
    ],
    dependencies: [
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "7.0.0")
    ],
    targets: [
        .target(
            name: "SwiftUIDay2Day",
            dependencies: ["Kingfisher"]),
        .testTarget(
            name: "SwiftUIDay2DayTests",
            dependencies: ["SwiftUIDay2Day"]),
    ]
)
