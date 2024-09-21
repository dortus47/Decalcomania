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
            resources: [
                "Decalcomania/Resources/**",
                "Decalcomania/OCR/**",
                .folderReference(path: "Decalcomania/tessdata") // 폴더 레퍼런스로 추가
            ],
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
