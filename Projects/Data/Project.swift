//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by leetaek on 2023/07/21.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "Data",
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
    resources: "Resource/**"
)
