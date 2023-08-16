//
//  WrittenBibleRealmRepository.swift
//  Store
//
//  Created by openobject on 2023/07/25.
//  Copyright © 2023 leetaek. All rights reserved.
//

import Foundation

struct WrittenBibleRealmRepository: Repository {
  typealias value = WrittenSentenceVO
  init() { }
  
  func create(data: WrittenSentenceVO) async throws {
    let dto = await toDTO(vo: data)
    do {
      try await BibleRealmDataSource.shared.create(data: dto)
    } catch {
      Log.debug(error)
    }
  }
  
  func read() async throws -> WrittenSentenceVO {
    do {
      let vo = try await BibleRealmDataSource.shared.read().toStore()
      return vo
    } catch {
      Log.debug(error)
      return WrittenSentenceVO.defaultValue
    }
  }
  
  func update(data: WrittenSentenceVO) async throws -> WrittenSentenceVO {
    let dto = await toDTO(vo: data)
    do {
      let vo = try await BibleRealmDataSource.shared.update(data: dto).toStore()
      return vo
    } catch {
      Log.debug(error)
      return data
    }

  }
  
  func delete(data: WrittenSentenceVO) async throws {
    let dto = await toDTO(vo: data)
    do {
      try await BibleRealmDataSource.shared.delete(data: dto)
    } catch {
      Log.debug(error)
    }
  }
  
  @BibleRealmDataSource
  func toDTO(vo: WrittenSentenceVO) async -> WrittenBibleRealmDTO {
    return await .init(bibleSentence: vo.bible)
  }
}
