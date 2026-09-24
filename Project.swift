import Foundation
import ProjectDescription

let secretsPath = "Configs/Secrets.xcconfig"

let secretsConfigurations: [Configuration] = {
    guard FileManager.default.fileExists(atPath: secretsPath) else {
        return []
    }

    let xcconfig = Path.relativeToRoot(secretsPath)

    return [
        .debug(name: "Debug", xcconfig: xcconfig),
        .release(name: "Release", xcconfig: xcconfig)
    ]
}()

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
            settings: .settings(configurations: secretsConfigurations)
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
