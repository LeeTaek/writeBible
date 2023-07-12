import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "WriteBible",
    platform: .iOS,
    product: .app,
    packages: [.Firebase, .TCACoordinator, .TCAArchitecture],
    dependencies: [
      .project(target: "Bible", path: .relativeToRoot("Projects/Bible")),
      .Firebase,
      .TCAArchitecture,
      .TCACoordinator
    ],
    sources: "WriteBible/Source/**",
    resources: "WriteBible/Resource/**",
    infoPlist: .file(path:  "WriteBible/Resource/Info.plist")
)
