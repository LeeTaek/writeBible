//
//  SettingRepositoryDI.swift
//  Carve
//
//  Created by openobject on 2023/07/13.
//  Copyright © 2023 leetaek. All rights reserved.
//

import Dependencies

struct SettingRepositoryDI: RealmDependency {
  typealias value = SettingVO
  var fetch: @Sendable () async throws -> SettingVO?
  var update: @Sendable (SettingVO) async throws -> SettingVO
}

extension SettingRepositoryDI: DependencyKey {
  static var liveValue: SettingRepositoryDI = {
    let repository = SettingRealmRepository()
    return .init(fetch: {
      try await repository.read()
    }, update: { data in
      try await repository.update(data: data)
    })
  }()

  static let testValue: SettingRepositoryDI = Self(
    fetch: {
      return SettingVO.defaultValue
    }, update: { _ in
      return SettingVO.defaultValue
    })
}


extension DependencyValues {
  var settingRepository: SettingRepositoryDI {
    get { self[SettingRepositoryDI.self]}
    set { self[SettingRepositoryDI.self] = newValue }
  }
}

