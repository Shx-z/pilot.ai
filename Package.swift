// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "pilot.ai",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "PilotAI",
            targets: ["PilotAI"]
        )
    ],
    targets: [
        .target(
            name: "PilotAI",
            path: "PilotAI"
        )
    ]
)
