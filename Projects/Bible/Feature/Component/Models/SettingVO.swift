//
//  SettingModel.swift
//  WriteBible
//
//  Created by 이택성 on 2022/06/27.
//

//import Foundation
import SwiftUI

import ComposableArchitecture

struct SettingModel: Hashable {
    var lineSpace: CGFloat
    var fontSize: CGFloat
    var traking: CGFloat
    var baseLineHeight: CGFloat = .zero
    var font: FontCase = .gothic

}

public struct SettingVO: Hashable {
  public var lineSpace: CGFloat
  public var fontSize: CGFloat
  public var traking: CGFloat
  public var baseLineHeight: CGFloat
  public var font: FontCase
  
  public func toDTO() -> SettingRealmDTO {
    return SettingRealmDTO(lineSpace: lineSpace,
                           fontSize: fontSize,
                           traking: traking,
                           baseLineHeight: baseLineHeight,
                           font: font.rawValue)
  }
}


public enum FontCase: String, CaseIterable {
    case gothic = "NanumBarunGothic"
    case myeongjo = "NanumMyeongjo"
    case flower = "나눔손글씨 꽃내음"
}
