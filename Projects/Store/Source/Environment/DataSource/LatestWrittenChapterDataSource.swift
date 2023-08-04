//
//  LatestWrittenChapterDataSource.swift
//  Store
//
//  Created by openobject on 2023/08/03.
//  Copyright © 2023 leetaek. All rights reserved.
//

import Foundation

import RealmSwift

@globalActor
actor LatestWrittenChapterDataSource: RealmDataSource {
  static let shared = LatestWrittenChapterDataSource()
  typealias value = LatestWrittenChapterRealmDTO

  func create(data: LatestWrittenChapterRealmDTO) async throws {
    do {
      guard let realm = await realm else { throw RealmObjectError.realmInitFailure }
      try await realm.asyncWrite {
        realm.create(LatestWrittenChapterRealmDTO.self, value: data)
      }
    } catch {
      Log.debug("fail in create data: \(error)")
      throw RealmObjectError.savedFailure
    }
  }
  
  func read() async throws -> LatestWrittenChapterRealmDTO {
    do {
      guard let realm = await realm else { throw RealmObjectError.realmInitFailure }
      let loadedData = realm.objects(LatestWrittenChapterRealmDTO.self)
      guard let setting = loadedData.first else {
            throw RealmObjectError.notFoundSettingData
          }
      return setting
    } catch {
      Log.debug("fail in read data: \(error)")
      throw RealmObjectError.notFoundSettingData
    }
  }
  
  func update(data: LatestWrittenChapterRealmDTO) async throws -> LatestWrittenChapterRealmDTO {
    let value = ["title": data.title,
                 "chapter": data.chapter
    ] as [String : Any]
    do {
      guard let realm = await realm else { throw RealmObjectError.realmInitFailure }
      try await realm.asyncWrite {
        realm.create(LatestWrittenChapterRealmDTO.self, value: value, update: .modified)
      }
    } catch {
      Log.debug("fail in update data: \(error)")
      throw RealmObjectError.updatedFailure
    }
    return data
  }
  
  func delete(data: LatestWrittenChapterRealmDTO) async throws {
    do {
      guard let realm = await realm else { throw RealmObjectError.realmInitFailure }
      try await realm.asyncWrite {
        realm.delete(data)
      }
    } catch {
      Log.debug("fail in delete data: \(error)")
      throw RealmObjectError.deleteFailure
    }
  }
}
