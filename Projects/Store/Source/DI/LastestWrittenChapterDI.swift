//
//  LastestWrittenChapterDI.swift
//  Store
//
//  Created by openobject on 2023/08/03.
//  Copyright © 2023 leetaek. All rights reserved.
//

import Dependencies

struct LatestWrittenChapterDI: RealmDependency {
  typealias value = LatestWrittenChapterVO
  var fetch: @Sendable () async throws -> LatestWrittenChapterVO?
  var update: @Sendable (LatestWrittenChapterVO) async throws -> LatestWrittenChapterVO
}

extension LatestWrittenChapterDI: DependencyKey {
  static var liveValue: LatestWrittenChapterDI = {
    let repository = LatestWrittenChapterRealmRepository()
    return .init(fetch: {
      try await repository.read()
    }, update: { data in
      try await repository.update(data: data)
    })
  }()
  
  static var previewValue: LatestWrittenChapterDI {
    return .init(fetch: {
      return LatestWrittenChapterVO.defaultValue
    }, update: { _ in
      return LatestWrittenChapterVO.defaultValue
    })
  }
}


extension DependencyValues {
  var latestWrittenChapterRepository: LatestWrittenChapterDI {
    get { self[LatestWrittenChapterDI.self] }
    set { self[LatestWrittenChapterDI.self] = newValue }
  }
}
