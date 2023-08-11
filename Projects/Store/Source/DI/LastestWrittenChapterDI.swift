//
//  LastestWrittenChapterDI.swift
//  Store
//
//  Created by openobject on 2023/08/03.
//  Copyright © 2023 leetaek. All rights reserved.
//

import Dependencies

public struct LatestWrittenChapterDI: RealmDependency {
  typealias value = LatestWrittenChapterVO
  public var fetch: @Sendable () async throws -> LatestWrittenChapterVO?
  public var update: @Sendable (LatestWrittenChapterVO) async throws -> LatestWrittenChapterVO
}

extension LatestWrittenChapterDI: DependencyKey {
  public static var liveValue: LatestWrittenChapterDI = {
    let repository = LatestWrittenChapterRealmRepository()
    return .init(fetch: {
      try await repository.read()
    }, update: { data in
      try await repository.update(data: data)
    })
  }()
  
  public static var previewValue: LatestWrittenChapterDI {
    return .init(fetch: {
      return LatestWrittenChapterVO.defaultValue
    }, update: { _ in
      return LatestWrittenChapterVO.defaultValue
    })
  }
}


public extension DependencyValues {
  var latestWrittenChapterRepository: LatestWrittenChapterDI {
    get { self[LatestWrittenChapterDI.self] }
    set { self[LatestWrittenChapterDI.self] = newValue }
  }
}
