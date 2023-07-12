import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "WriteBible",
    platform: .iOS,
    product: .app,
    dependencies: [
      .project(target: "Bible", path: .relativeToRoot("Projects/Bible")),
      .FirebaseAnalytics,
      .FirebaseMessaging,
      .TCAArchitecture,
      .TCACoordinator
    ],
    sources: "WriteBible/Source/**",
    resources: "WriteBible/Resource/**"
)
