//
//  BibleRealmDataSource.swift
//  Store
//
//  Created by openobject on 2023/07/25.
//  Copyright © 2023 leetaek. All rights reserved.
//

import Foundation

import RealmSwift

@globalActor
actor BibleRealmDataSource: RealmDataSource {
  static let shared = BibleRealmDataSource()
  typealias value = WrittenBibleRealmDTO
  var realm: Realm!
  
  func create(data: WrittenBibleRealmDTO) async throws {
    do {
      try await realm.asyncWrite {
        realm.create(WrittenBibleRealmDTO.self, value: data)
      }
    } catch {
      Log.debug("fail in create data: \(error)")
      throw RealmObjectError.savedFailure
    }
  }
  
  func read() async throws -> WrittenBibleRealmDTO {
    do {
      let loadedData = realm.objects(WrittenBibleRealmDTO.self)
      guard let setting = loadedData.first else {
        throw RealmObjectError.notFoundSettingData
      }
      return setting
    } catch {
      Log.debug("fail in read data: \(error)")
      throw RealmObjectError.notFoundSettingData
    }

  }
  
  func update(data: WrittenBibleRealmDTO) async throws -> WrittenBibleRealmDTO {
    let value = ["id": data.id,
                 "writtenData": data.writtenData,
                 "bibleSentence": data.bibleSentence,
                 "isWritten": data.isWritten
    ] as [String : Any]
    do {
      try await realm.asyncWrite {
        realm.create(WrittenBibleRealmDTO.self, value: value, update: .modified)
      }
    } catch {
      Log.debug("fail in update data: \(error)")
      throw RealmObjectError.updatedFailure
    }
    return data
  }
  
  func delete(data: WrittenBibleRealmDTO) async throws {
    do {
      try await realm.asyncWrite {
        realm.delete(data)
      }
    } catch {
      Log.debug("fail in delete data: \(error)")
      throw RealmObjectError.deleteFailure
    }
  }
  
}
