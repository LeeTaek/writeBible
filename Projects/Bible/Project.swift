//
//  Project.swift
//  writeBibleManifests
//
//  Created by leetaek on 2023/07/11.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "Bible",
    product: .staticFramework,
    dependencies: [
      .RealmSwift,
      .TCAArchitecture,
      .TCACoordinator
    ],
    sources: "Feature/**"
)
