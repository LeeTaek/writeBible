//
//  SettingDTO.swift
//  Bible
//
//  Created by openobject on 2023/07/20.
//  Copyright © 2023 leetaek. All rights reserved.
//

import Foundation

public struct SettingDTO {
  public let lineSpace: CGFloat?
  public let fontSize: CGFloat?
  public let traking: CGFloat?
  public let baseLineHeight: CGFloat?
  public let lineCount: Int?
  public let font: FontCase?
}

public enum FontCase: String,
                      CaseIterable {
  case gothic = "NanumBarunGothic"
  case myeongjo = "NanumMyeongjo"
  case flower = "나눔손글씨 꽃내음"
}


public extension SettingDTO {
  func toDomain() -> SettingRepository {
    return SettingRepository(lineSpace: self.lineSpace,
                             fontSize: self.fontSize,
                             traking: self.traking,
                             baseLineHeight: self.baseLineHeight,
                             lineCount: self.lineCount,
                             font: self.font)
  }
}
