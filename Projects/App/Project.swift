import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "Carve",
    platform: .iOS,
    product: .app,
    packages: [
      .Firebase
    ],
    dependencies: [
      .project(target: "Bible", path: .relativeToRoot("Projects/Bible")),
      .FirebaseAnalytics,
      .FirebaseMessaging,
    ],
    sources: "Source/**",
    resources: "Resource/**",
    infoPlist: .file(path: "Support/Info.plist")
)
