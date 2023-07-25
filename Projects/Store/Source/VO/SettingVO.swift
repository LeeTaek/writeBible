//
//  SettingStore.swift
//  Bible
//
//  Created by 이택성 on 7/17/23.
//  Copyright © 2023 leetaek. All rights reserved.
//

import Foundation

public struct SettingVO: Hashable {
  public var lineSpace: CGFloat
  public var fontSize: CGFloat
  public var traking: CGFloat
  public var baseLineHeight: CGFloat
  public var font: FontCase
  
  public init(lineSpace: CGFloat, fontSize: CGFloat, traking: CGFloat, baseLineHeight: CGFloat, font: FontCase) {
    self.lineSpace = lineSpace
    self.fontSize = fontSize
    self.traking = traking
    self.baseLineHeight = baseLineHeight
    self.font = font
  }
  
  static public let defaultValue = Self(
    lineSpace: 20,
    fontSize: 20,
    traking: 1,
    baseLineHeight: 20,
    font: .flower
  )
}


public enum FontCase: String, CaseIterable {
    case gothic = "NanumBarunGothic"
    case myeongjo = "NanumMyeongjo"
    case flower = "나눔손글씨 꽃내음"
}
