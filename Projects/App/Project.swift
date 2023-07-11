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
    resources: "WriteBible/Support/**",
    infoPlist: .file(path:  "WriteBible/Support/Info.plist")
)
