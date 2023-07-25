//
//  Project.swift
//  CarveManifests
//
//  Created by leetaek on 2023/07/11.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "Bible",
    product: .staticFramework,
    packages: [
      .Realm,
      .TCAArchitecture,
      .TCACoordinator
    ],
    dependencies: [
      .project(target: "Store", path: .relativeToRoot("Projects/Store")),
      .RealmSwift,
      .TCAArchitecture,
      .TCACoordinator
    ],
    sources: "Feature/**",
    resources: "Feature/Component/DesignSystems/Resource/**"
//    resources: "Resource/**"
)
