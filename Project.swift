import ProjectDescription

let baseConfig: Path = "Configs/Base.xcconfig"

let project = Project(
    name: "recepies",
    targets: [
        .target(
            name: "recepies",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.recepies",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                    "SpoonacularApiKey": "$(SPOONACULAR_API_KEY)",
                ]
            ),
            sources: ["recepies/Sources/**"],
            resources: ["recepies/Resources/**"],
            dependencies: [],
            settings: .settings(configurations: [
                .debug(name: "Debug", xcconfig: baseConfig),
                .release(name: "Release", xcconfig: baseConfig),
            ])
        ),
        .target(
            name: "recepiesTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.recepiesTests",
            infoPlist: .default,
            sources: ["recepies/Tests/**"],
            resources: [],
            dependencies: [.target(name: "recepies")]
        ),
    ]
)
