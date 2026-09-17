// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "pilot.ai",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .executable(
            name: "PilotAI",
            targets: ["PilotAI"]
        )
    ],
    targets: [
        .executableTarget(
            name: "PilotAI",
            path: "PilotAI"
        )
    ]
)
