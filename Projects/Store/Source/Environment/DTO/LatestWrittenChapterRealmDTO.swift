//
//  LatestWrittenChapterRealmDTO.swift
//  Store
//
//  Created by openobject on 2023/08/03.
//  Copyright © 2023 leetaek. All rights reserved.
//

import Foundation

import RealmSwift

public class LatestWrittenChapterRealmDTO: Object {
  @Persisted(primaryKey: true) public var id = UUID()
  @Persisted public var title: String
  @Persisted public var chapter: Int
  
  convenience init(id: UUID = UUID(), title: String, chapter: Int) async {
    self.init()
    self.id = id
    self.title = title
    self.chapter = chapter
  }
  
  public func toStore() -> LatestWrittenChapterVO {
    return .init(title: BibleTitle(rawValue: title)!, chapter: chapter)
  }
}
