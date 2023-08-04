//
//  LatestWrittenChapterVO.swift
//  Store
//
//  Created by openobject on 2023/08/03.
//  Copyright © 2023 leetaek. All rights reserved.
//

import Foundation

public struct LatestWrittenChapterVO: Hashable {
  public var title: String
  public var chapter: Int
  
  static public let defaultValue = Self(
    title: "창세기",
    chapter: 1
  )
}
