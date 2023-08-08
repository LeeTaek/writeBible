//
//  SettingDTO.swift
//  Bible
//
//  Created by openobject on 2023/07/20.
//  Copyright © 2023 leetaek. All rights reserved.
//

import Foundation

import RealmSwift

public class SettingRealmDTO: Object {
  @Persisted public var lineSpace: CGFloat
  @Persisted public var fontSize: CGFloat
  @Persisted public var traking: CGFloat
  @Persisted public var baseLineHeight: CGFloat
  @Persisted public var font: String

  public convenience init(lineSpace: CGFloat, fontSize: CGFloat, traking: CGFloat, baseLineHeight: CGFloat, font: String) {
    self.init()
    self.lineSpace = lineSpace
    self.fontSize = fontSize
    self.traking = traking
    self.baseLineHeight = baseLineHeight
     self.font = font
  }
    
  public func toStore() -> SettingVO {
    return .init(lineSpace: lineSpace,
                 fontSize: fontSize,
                 traking: traking,
                 baseLineHeight: baseLineHeight,
                 font: FontCase(rawValue: font) ?? .flower)
  }
}

