//
//  SettingRealmClient.swift
//  Bible
//
//  Created by openobject on 2023/07/21.
//  Copyright © 2023 leetaek. All rights reserved.
//

import Foundation

import RealmSwift

@globalActor
actor SettingRealmDataSrouce: RealmDataSource {
  static let shared = SettingRealmDataSrouce()
  typealias value = SettingRealmDTO
  
  func create(data: SettingRealmDTO) async throws {
    do {
      guard let realm = await realm else { throw RealmObjectError.realmInitFailure }
      try await realm.asyncWrite {
        realm.create(SettingRealmDTO.self, value: data)
      }
    } catch {
      Log.error("fail in create data: \(error)")
      throw RealmObjectError.savedFailure
    }
  }
  
  func read() async throws -> SettingRealmDTO {
    do {
      guard let realm = await realm else { throw RealmObjectError.realmInitFailure }
      let loadedData = realm.objects(SettingRealmDTO.self)
      guard let setting = loadedData.first else {
        throw RealmObjectError.notFoundSettingData
      }
      return setting
    } catch {
      Log.error("fail in read data: \(error)")
      throw RealmObjectError.notFoundSettingData
    }
  }
  
  func update(data: SettingRealmDTO) async throws -> SettingRealmDTO {
    let value = ["fontSize": data.fontSize,
                 "tracking": data.traking,
                 "lineSpace": data.lineSpace,
                 "baseLineHeight": data.baseLineHeight,
                 "font": data.font
    ] as [String : Any]
    do {
      guard let realm = await realm else { throw RealmObjectError.realmInitFailure }
      try await realm.asyncWrite {
        realm.create(SettingRealmDTO.self, value: value, update: .modified)
      }
    } catch {
      Log.error("fail in update data: \(error)")
      throw RealmObjectError.updatedFailure
    }
    return data
  }
  
  func delete(data: SettingRealmDTO) async throws {
    do {
      guard let realm = await realm else { throw RealmObjectError.realmInitFailure }
      try await realm.asyncWrite {
        realm.delete(data)
      }
    } catch {
      Log.error("fail in delete data: \(error)")
      throw RealmObjectError.deleteFailure
    }
  }
}

