//
//  LatestWrittenChapterVO.swift
//  Store
//
//  Created by openobject on 2023/08/03.
//  Copyright © 2023 leetaek. All rights reserved.
//

import Foundation

public struct LatestWrittenChapterVO: Hashable {
  public var title: BibleTitle
  public var chapter: Int
  
  public init(title: BibleTitle, chapter: Int) {
    self.title = title
    self.chapter = chapter
  }
  
  static public let defaultValue = Self(
    title: .genesis,
    chapter: 1
  )
}
