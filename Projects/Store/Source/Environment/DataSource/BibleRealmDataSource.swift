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
  
  func create(data: WrittenBibleRealmDTO) async throws {
    do {
      guard let realm = await realm else { throw RealmObjectError.realmInitFailure }
      try await realm.asyncWrite {
        realm.create(WrittenBibleRealmDTO.self, value: data)
      }
    } catch {
      Log.error("fail in create data: \(error)")
      throw RealmObjectError.savedFailure
    }
  }
  
  func read() async throws -> WrittenBibleRealmDTO {
    do {
      guard let realm = await realm else { throw RealmObjectError.realmInitFailure }
      let loadedData = realm.objects(WrittenBibleRealmDTO.self)
      guard let setting = loadedData.first else {
        throw RealmObjectError.notFoundSettingData
      }
      return setting
    } catch {
      Log.error("fail in read data: \(error)")
      throw RealmObjectError.notFoundSettingData
    }

  }
  
  func update(data: WrittenBibleRealmDTO) async throws -> WrittenBibleRealmDTO {
    let value = ["id": data.id,
                 "writtenData": data.writtenData ?? Data(),
                 "bibleSentence": data.bibleSentence
    ] as [String : Any]
    do {
      guard let realm = await realm else { throw RealmObjectError.realmInitFailure }
      try await realm.asyncWrite {
        realm.create(WrittenBibleRealmDTO.self, value: value, update: .modified)
      }
    } catch {
      Log.error("fail in update data: \(error)")
      throw RealmObjectError.updatedFailure
    }
    return data
  }
  
  func delete(data: WrittenBibleRealmDTO) async throws {
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
