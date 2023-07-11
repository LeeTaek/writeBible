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
    packages: [.Realm, .TCAArchitecture, .TCACoordinator],
    dependencies: [
        .Realm,
        .TCAArchitecture,
        .TCACoordinator
    ]
)
