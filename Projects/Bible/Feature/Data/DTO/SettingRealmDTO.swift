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
  @Persisted var lineSpace: CGFloat
  @Persisted var fontSize: CGFloat
  @Persisted var traking: CGFloat
  @Persisted var baseLineHeight: CGFloat
  @Persisted var font: String

  init(lineSpace: CGFloat, fontSize: CGFloat, traking: CGFloat, baseLineHeight: CGFloat, font: String) {
    self.lineSpace = lineSpace
    self.fontSize = fontSize
    self.traking = traking
    self.baseLineHeight = baseLineHeight
    self.font = font
  }
  
  enum SettingRealmObjectError: Error {
    case savedFailure
    case notFoundSettingData
    case updatedFailure
    case deleteFailure
  }
  
  func toDomain() -> SettingVO {
    return SettingVO(
      lineSpace: self.lineSpace,
      fontSize: self.fontSize,
      traking: self.traking,
      baseLineHeight: self.baseLineHeight,
      font: FontCase(rawValue: font) ?? .flower
    )
  }
}

