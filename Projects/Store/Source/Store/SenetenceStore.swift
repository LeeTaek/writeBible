//
//  SenetenceStore.swift
//  Store
//
//  Created by openobject on 2023/07/26.
//  Copyright © 2023 leetaek. All rights reserved.
//

import Foundation

import ComposableArchitecture

public struct SentenceStore: Reducer {
  public init() { }
  
  public struct State: Equatable, Identifiable {
    public let id: UUID
    public var sentence: BibleSentenceVO
    public var setting: SettingVO = .defaultValue
    public var textHeight: CGFloat = .zero
    public var line: Int = 3
    
    public init(id: UUID, sentence: BibleSentenceVO) {
      self.id = id
      self.sentence = sentence
    }
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case onAppear(BibleSentenceVO)
    case getLine(CGFloat)
    case updateSettingResponse(TaskResult<SettingVO>)
    case updateBaseLineHeight(CGFloat)
  }
  
  
//  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
  public var body: some ReducerOf<Self> {
    BindingReducer()
    
    Reduce { state, action in
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
      default:
        return .none
      }
    }
    ._printChanges()
  }
  
}
