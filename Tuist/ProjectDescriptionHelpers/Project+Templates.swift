//
//  Project+Templates.swift
//  CarveManifests
//
//  Created by leetaek on 2023/07/11.
//

import ProjectDescription

public extension Project {
  static func makeModule(
    name: String,
    platform: Platform = .iOS,
    product: Product,
    organizationName: String = "leetaek",
    packages: [Package] = [],
    deploymentTarget: DeploymentTarget? = .iOS(targetVersion: "15.0", devices: [.ipad]),
    dependencies: [TargetDependency] = [],
    sources: SourceFilesList = "Source/**",
    resources: ResourceFileElements? = nil,
    testSource: SourceFilesList? = nil,
    infoPlist: InfoPlist = .default
  ) -> Project {
    let settings: Settings = .settings(
      base: [:],
      configurations: [
        .debug(name: .debug),
        .release(name: .release)
      ], defaultSettings: .recommended)
    
    let appTarget = Target(
      name: name,
      platform: platform,
      product: product,
      bundleId: product == .app ? "kr.co.\(organizationName).\(name)" : "kr.co.\(organizationName).Carve.\(name)",
      deploymentTarget: deploymentTarget,
      infoPlist: infoPlist,
      sources: sources,
      resources: resources,
      dependencies: dependencies
    )
    
    let testTarget = Target(
      name: "\(name)Test",
      platform: platform,
      product: .unitTests,
      bundleId: "\(organizationName).\(name)Test",
      deploymentTarget: deploymentTarget,
      infoPlist: .default,
      sources: testSource,
      dependencies: [.target(name: name)]
    )
    
    let schemes: [Scheme] = [.makeScheme(target: .debug, name: name)]
    
    var targets: [Target] = [appTarget]
    
    if product != .app {
      targets.append(testTarget)
    }
    
    
    return Project(
      name: name,
      organizationName: organizationName,
      packages: packages,
      settings: settings,
      targets: targets,
      schemes: schemes
    )
  }
}

extension Scheme {
  static func makeScheme(target: ConfigurationName, name: String) -> Scheme {
    return Scheme(
      name: name,
      shared: true,
      buildAction: .buildAction(targets: ["\(name)"]),
      testAction: .targets(
        ["\(name)Test"],
        configuration: target,
        options: .options(coverage: true, codeCoverageTargets: ["\(name)"])
      ),
      runAction: .runAction(configuration: target),
      archiveAction: .archiveAction(configuration: target),
      profileAction: .profileAction(configuration: target),
      analyzeAction: .analyzeAction(configuration: target)
    )
  }
}


// MARK: Extension

public extension TargetDependency {
  static let RealmSwift: TargetDependency = .package(product: "RealmSwift")
  static let TCAArchitecture: TargetDependency = .package(product:  "ComposableArchitecture")
  static let FirebaseAnalytics: TargetDependency = .package(product:  "FirebaseAnalyticsSwift")
  static let FirebaseMessaging: TargetDependency = .package(product:  "FirebaseMessaging")
  static let TCACoordinator: TargetDependency = .package(product: "TCACoordinators")
}


public extension Package {
  static let Realm: Package = .remote(url: "https://github.com/realm/realm-swift", requirement: .upToNextMajor(from: "10.42.0"))
  static let Firebase: Package = .remote(url: "https://github.com/firebase/firebase-ios-sdk.git", requirement: .upToNextMajor(from: "10.11.0"))
  static let TCAArchitecture: Package = .remote(url: "https://github.com/pointfreeco/swift-composable-architecture", requirement: .upToNextMajor(from: "1.0.0"))
  static let TCACoordinator: Package = .remote(url: "https://github.com/johnpatrickmorgan/TCACoordinators", requirement: .upToNextMajor(from: "0.6.0"))
}

