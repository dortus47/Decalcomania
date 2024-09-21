import ProjectDescription

let project = Project(
    name: "Decalcomania",
    targets: [
        .target(
            name: "Decalcomania",
            destinations: .macOS,
            product: .app,
            bundleId: "io.tuist.Decalcomania",
            infoPlist: .default,
            sources: ["Decalcomania/Sources/**"],
            resources: ["Decalcomania/Resources/**"],
            dependencies: []
        ),
        .target(
            name: "DecalcomaniaTests",
            destinations: .macOS,
            product: .unitTests,
            bundleId: "io.tuist.DecalcomaniaTests",
            infoPlist: .default,
            sources: ["Decalcomania/Tests/**"],
            resources: [],
            dependencies: [.target(name: "Decalcomania")]
        ),
    ]
)
