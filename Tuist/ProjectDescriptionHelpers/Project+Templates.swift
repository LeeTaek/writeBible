//
//  Project+Templates.swift
//  writeBibleManifests
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
    deploymentTarget: DeploymentTarget? = .iOS(targetVersion: "15.0", devices: [.iphone]),
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
    
    var appTarget = Target(
      name: name,
      platform: platform,
      product: product,
      bundleId: product == .app ? "kr.co.\(organizationName).\(name)" : "kr.co.\(organizationName).writebible.\(name)",
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




// MARK: SourceFile
public extension SourceFilesList {
    static let sources: SourceFilesList = "Source/**"
    static let tests: SourceFilesList = "Test/**"
}


// MARK: Resource
public enum ResourceType: String {
    case xibs = "Source/**/*.xib"
    case storyboards = "Resources/**/*.storyboard"
    case assets = "WriteBible/Resource/**"
}

// MARK: Extension
public extension Array where Element == FileElement {
    static func resources(with resources: [ResourceType]) -> [FileElement] {
        resources.map { FileElement(stringLiteral: $0.rawValue) }
    }
}


public extension TargetDependency {
  static let Realm: TargetDependency = .package(product: "Realm")
  static let TCAArchitecture: TargetDependency = .package(product: "TCAArchitecture")
  static let Firebase: TargetDependency = .package(product: "Firebase")
  static let TCACoordinator: TargetDependency = .package(product: "TCACoordinator")
}

public extension Package {
  static let Realm: Package = .package(url: "https://github.com/realm/realm-swift", .branch("master"))
  static let TCAArchitecture: Package = .package(url: "https://github.com/pointfreeco/swift-composable-architecture", .upToNextMajor(from: "0.55.0"))
  static let Firebase: Package = .package(url: "https://github.com/firebase/firebase-ios-sdk.git", .upToNextMajor(from: "10.11.0"))
  static let TCACoordinator: Package = .package(url: "https://github.com/johnpatrickmorgan/TCACoordinators", .upToNextMajor(from: "0.4.0"))
}
