//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by leetaek on 2023/07/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "Store",
    product: .staticFramework,
    packages: [
      .Realm,
      .TCAArchitecture,
    ],
    dependencies: [
      .RealmSwift,
      .TCAArchitecture,
    ],
    sources: "Source/**",
    resources: "Resource/**",
    testSource: "UnitTest/**"
)
