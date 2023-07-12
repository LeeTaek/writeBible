//
//  Dependencies.swift
//  Config
//
//  Created by leetaek on 2023/07/12.
//

import ProjectDescription
import ProjectDescriptionHelpers

let dependencies = Dependencies(
  swiftPackageManager: .init(
    [
    .Firebase,
    .Realm,
    .TCAArchitecture,
    .TCACoordinator
  ],
    productTypes: [
      "firebase-ios-sdk" : .framework,
      "realm-swift": .framework,
      "swift-composable-architecture": .framework,
      "TCACoordinators": .framework
    ]
  ),
  platforms: [.iOS]
)

