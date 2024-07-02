import ProjectDescription

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
                ]
            ),
            sources: ["recepies/Sources/**"],
            resources: ["recepies/Resources/**"],
            dependencies: []
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
