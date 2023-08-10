import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "Carve",
    platform: .iOS,
    product: .app,
    packages: [
      .Firebase,
        .TCAArchitecture,
        .TCACoordinator

    ],
    dependencies: [
      .project(target: "Bible", path: .relativeToRoot("Projects/Bible")),
      .project(target: "Store", path: .relativeToRoot("Projects/Store")),
      .FirebaseAnalytics,
      .FirebaseMessaging,
    ],
    sources: "Source/**",
    resources: "Resource/**",
    infoPlist: .file(path: "Support/Info.plist")
)
