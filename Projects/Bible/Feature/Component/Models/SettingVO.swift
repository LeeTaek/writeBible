//
//  SettingModel.swift
//  WriteBible
//
//  Created by 이택성 on 2022/06/27.
//

//import Foundation
import SwiftUI
import Store

import ComposableArchitecture

struct SettingModel: Hashable {
    var lineSpace: CGFloat
    var fontSize: CGFloat
    var traking: CGFloat
    var baseLineHeight: CGFloat = .zero
    var font: FontCase = .gothic
}

enum FontCase: String, CaseIterable {
    case gothic = "NanumBarunGothic"
    case myeongjo = "NanumMyeongjo"
    case flower = "나눔손글씨 꽃내음"
}
