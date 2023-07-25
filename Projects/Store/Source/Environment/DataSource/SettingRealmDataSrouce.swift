//
//  SettingRealmClient.swift
//  Bible
//
//  Created by openobject on 2023/07/21.
//  Copyright © 2023 leetaek. All rights reserved.
//

import Foundation

import RealmSwift

final class SettingRealmDataSrouce: RealmDataSource {
  typealias value = SettingRealmDTO
  static let shared = SettingRealmDataSrouce()
  var realm: Realm!
  var realmQueue: DispatchQueue!
  
  func create(data: SettingRealmDTO) async throws {
    try await withCheckedThrowingContinuation { continuation in
      realmQueue.async { [self] in
        do {
          try realm.write {
            realm.add(data)
          }
          continuation.resume()
        } catch {
          Log.debug("fail in create data: \(error)")
          continuation.resume(throwing: SettingRealmDTO.SettingRealmObjectError.savedFailure)
        }
      }
    }
  }
  
  func read() async throws -> SettingRealmDTO {
    try await withCheckedThrowingContinuation { continuation in
      realmQueue.async { [self] in
        let loadedData = realm.objects(SettingRealmDTO.self)
        guard let setting = loadedData.first else {
          Log.debug("fail in read data: \(SettingRealmDTO.SettingRealmObjectError.notFoundSettingData)")
          continuation.resume(throwing: SettingRealmDTO.SettingRealmObjectError.notFoundSettingData)
          return
        }
        continuation.resume(returning: setting)
      }
    }
  }
  
  func update(data: SettingRealmDTO) async throws -> SettingRealmDTO {
    try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<SettingRealmDTO, Error>) -> Void in
      realmQueue.async { [self] in
        let loadedData = realm.objects(SettingRealmDTO.self)
        guard let setting = loadedData.first else {
          Log.debug("fail in update data: \(SettingRealmDTO.SettingRealmObjectError.notFoundSettingData)")
          continuation.resume(throwing: SettingRealmDTO.SettingRealmObjectError.notFoundSettingData)
          return
        }
        do {
          try realm.write {
            setting.fontSize = data.fontSize
            setting.traking = data.traking
            setting.lineSpace = data.lineSpace
            setting.baseLineHeight = data.baseLineHeight
            setting.font = data.font
          }
          continuation.resume(returning: data)
        } catch {
          Log.debug("fail in update data: \(error)")
          continuation.resume(throwing: SettingRealmDTO.SettingRealmObjectError.updatedFailure)
        }
      }
    }
  }
  
  func delete(data: SettingRealmDTO) async throws {
    try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) -> Void in
      realmQueue.async { [self] in
        let loadedData = realm.objects(SettingRealmDTO.self)
        guard let setting = loadedData.first else {
          Log.debug("fail in update data: \(SettingRealmDTO.SettingRealmObjectError.notFoundSettingData)")
          continuation.resume(throwing: SettingRealmDTO.SettingRealmObjectError.notFoundSettingData)
          return
        }
        do {
          try realm.write {
            realm.delete(setting)
          }
          continuation.resume()
        } catch {
          Log.debug("fail in delete data: \(error)")
          continuation.resume(throwing: SettingRealmDTO.SettingRealmObjectError.deleteFailure)
        }
      }
    }
  }
}

