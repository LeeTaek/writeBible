//
//  SenetenceStore.swift
//  Store
//
//  Created by openobject on 2023/07/26.
//  Copyright © 2023 leetaek. All rights reserved.
//

import Foundation

import ComposableArchitecture
import RealmSwift

public struct SentenceStore: Reducer {
  public init() { }
  
  public struct State: Equatable, Identifiable {
    public static func == (lhs: SentenceStore.State, rhs: SentenceStore.State) -> Bool {
      lhs.id == rhs.id
    }
    
    @ObservedResults(WrittenBibleRealmDTO.self) public var drawings
    public let id: String
    public var sentence: BibleSentenceVO
    public var setting: SettingVO = .defaultValue
    public var textHeight: CGFloat = .zero
    public var line: Int = 3
    
    public init(sentence: BibleSentenceVO) {
      self.sentence = sentence
      self.id = "\(sentence.title).\(sentence.chapter.description).\(sentence.section.description)"
    }
  }
  
  public enum Action: Equatable {
    case onAppear(BibleSentenceVO)
    case getLine(CGFloat)
    case updateSettingResponse(TaskResult<SettingVO>)
    case updateBaseLineHeight(CGFloat)
  }
  
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
      switch action {
      case .onAppear(let sentence):
        Log.debug("sentenceStore :\(sentence)")
        return .none
      case let .getLine(textHeight):
        state.textHeight = textHeight
        state.line = Int((state.textHeight + state.setting.lineSpace + 25) / (state.setting.baseLineHeight + state.setting.lineSpace)) + 1
        return .none
      case let .updateSettingResponse(.success(settingVO)):
        state.setting = settingVO
        return .none
      case .updateSettingResponse(.failure(_)):
        return .none
      case let .updateBaseLineHeight(lineHeight):
        state.setting.baseLineHeight = lineHeight
        return .none
      }
    }
}
