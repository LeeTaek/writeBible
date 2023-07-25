//
//  BibleRealmDataSource.swift
//  Store
//
//  Created by openobject on 2023/07/25.
//  Copyright © 2023 leetaek. All rights reserved.
//

import Foundation

import RealmSwift

final class BibleRealmDataSource: RealmDataSource {
  typealias value = WrittenBibleRealmDTO
  static let shared = BibleRealmDataSource()
  var realm: Realm!
  var realmQueue: DispatchQueue!
  
  func create(data: WrittenBibleRealmDTO) async throws {
    try await withCheckedThrowingContinuation { continuation in
      realmQueue.async { [self] in
        do {
          try realm.write {
            realm.add(data)
          }
          continuation.resume()
        } catch {
          Log.debug("fail in create data: \(error)")
          continuation.resume(throwing: RealmObjectError.savedFailure)
        }
      }
    }
  }
  
  func read() async throws -> WrittenBibleRealmDTO {
    try await withCheckedThrowingContinuation { continuation in
      realmQueue.async { [self] in
        let loadedData = realm.objects(WrittenBibleRealmDTO.self)
        guard let setting = loadedData.first else {
          Log.debug("fail in read data: \(RealmObjectError.notFoundSettingData)")
          continuation.resume(throwing: RealmObjectError.notFoundSettingData)
          return
        }
        continuation.resume(returning: setting)
      }
    }
  }
  
  func update(data: WrittenBibleRealmDTO) async throws -> WrittenBibleRealmDTO {
    try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<WrittenBibleRealmDTO, Error>) -> Void in
      realmQueue.async { [self] in
        let loadedData = realm.objects(WrittenBibleRealmDTO.self)
        guard let writtenData = loadedData.first else {
          Log.debug("fail in update data: \(RealmObjectError.notFoundSettingData)")
          continuation.resume(throwing: RealmObjectError.notFoundSettingData)
          return
        }
        do {
          try realm.write {
            writtenData.writtenData = data.writtenData
            writtenData.bibleSentence = data.bibleSentence
            writtenData.isWritten = data.isWritten
          }
          continuation.resume(returning: data)
        } catch {
          Log.debug("fail in update data: \(error)")
          continuation.resume(throwing: RealmObjectError.updatedFailure)
        }
      }
    }
  }
  
  func delete(data: WrittenBibleRealmDTO) async throws {
    try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) -> Void in
      realmQueue.async { [self] in
        let loadedData = realm.objects(WrittenBibleRealmDTO.self)
        guard let setting = loadedData.first else {
          Log.debug("fail in update data: \(RealmObjectError.notFoundSettingData)")
          continuation.resume(throwing: RealmObjectError.notFoundSettingData)
          return
        }
        do {
          try realm.write {
            realm.delete(setting)
          }
          continuation.resume()
        } catch {
          Log.debug("fail in delete data: \(error)")
          continuation.resume(throwing: RealmObjectError.deleteFailure)
        }
      }
    }
  }
  
}
