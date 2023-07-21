//
//  SettingRealmRepository.swift
//  Bible
//
//  Created by openobject on 2023/07/20.
//  Copyright © 2023 leetaek. All rights reserved.
//

import Foundation

import Dependencies

struct SettingRealmRepository: RealmRepository {
  typealias value = SettingVO
  var fetch: @Sendable () async throws -> SettingVO
}


extension SettingRealmRepository: DependencyKey {
  static var liveValue: SettingRealmRepository = Self(
    fetch: { 
      try await SettingRealmDataSrouce.shared.read().toDomain()
    })
  
  static let testValue: SettingRealmRepository = Self(
    fetch: {
      return SettingRealmDTO(lineSpace: 20,
                             fontSize: 20,
                             traking: 1,
                             baseLineHeight: 20,
                             font: FontCase.flower.rawValue
      )
      .toDomain()
    })
}


extension DependencyValues {
  var settingRepository: SettingRealmRepository {
    get { self[SettingRealmRepository.self]}
    set { self[SettingRealmRepository.self] = newValue }
  }
}

