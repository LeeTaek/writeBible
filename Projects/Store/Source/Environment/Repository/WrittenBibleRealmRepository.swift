//
//  WrittenBibleRealmRepository.swift
//  Store
//
//  Created by openobject on 2023/07/25.
//  Copyright © 2023 leetaek. All rights reserved.
//

import Foundation

struct WrittenBibleRealmRepository: Repository {
  typealias value = WrittenBibleVO
  init() { }
  
  func create(data: WrittenBibleVO) async throws {
    let dto = toDTO(vo: data)
    do {
      try await BibleRealmDataSource.shared.create(data: dto)
    } catch {
      Log.debug(error)
    }
  }
  
  func read() async throws -> WrittenBibleVO {
    do {
      let vo = try await BibleRealmDataSource.shared.read().toStore()
      return vo
    } catch {
      Log.debug(error)
      return WrittenBibleVO.defaultValue
    }
  }
  
  func update(data: WrittenBibleVO) async throws -> WrittenBibleVO {
    let dto = toDTO(vo: data)
    do {
      let vo = try await BibleRealmDataSource.shared.update(data: dto).toStore()
      return vo
    } catch {
      Log.debug(error)
      return data
    }

  }
  
  func delete(data: WrittenBibleVO) async throws {
    let dto = toDTO(vo: data)
    do {
      try await BibleRealmDataSource.shared.delete(data: dto)
    } catch {
      Log.debug(error)
    }
  }
  
  func toDTO(vo: WrittenBibleVO) -> WrittenBibleRealmDTO {
    return .init(writtenData: vo.writtenData,
                 bibleSentence: vo.bible,
                 isWritten: vo.isWrite
    )
  }
}
