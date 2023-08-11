//
//  LatestWrittenChapterRealmRepository.swift
//  Store
//
//  Created by openobject on 2023/08/03.
//  Copyright © 2023 leetaek. All rights reserved.
//

import Foundation

struct LatestWrittenChapterRealmRepository: Repository {
  typealias value = LatestWrittenChapterVO
  init() { }
  
  func create(data: LatestWrittenChapterVO) async throws {
    let dto = await toDTO(vo: data)
    do {
      try await LatestWrittenChapterDataSource.shared.create(data: dto)
    } catch {
      Log.debug(error)
    }
  }
  
  func read() async throws -> LatestWrittenChapterVO {
    do {
      let vo = try await LatestWrittenChapterDataSource.shared.read().toStore()
      return vo
    } catch {
      Log.debug(error)
      return LatestWrittenChapterVO(title: .genesis, chapter: 1)
    }
  }
  
  func update(data: LatestWrittenChapterVO) async throws -> LatestWrittenChapterVO {
    let dto = await toDTO(vo: data)
    do {
      let vo = try await LatestWrittenChapterDataSource.shared.update(data: dto).toStore()
      return vo
    } catch {
      Log.debug(error)
      return data
    }
  }
  
  func delete(data: LatestWrittenChapterVO) async throws {
    let dto = await toDTO(vo: data)
    do {
      try await LatestWrittenChapterDataSource.shared.delete(data: dto)
    } catch {
      Log.debug(error)
    }
  }
  
  @LatestWrittenChapterDataSource
  func toDTO(vo: LatestWrittenChapterVO) async -> LatestWrittenChapterRealmDTO {
    return await .init(title: vo.title.rawValue, chapter: vo.chapter)
  }
  
}
