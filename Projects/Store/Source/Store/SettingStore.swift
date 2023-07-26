//
//  SettingStore.swift
//  Bible
//
//  Created by 이택성 on 7/17/23.
//  Copyright © 2023 leetaek. All rights reserved.
//

import Foundation

import ComposableArchitecture

public struct SettingStore: ReducerProtocol {
    public struct State: Equatable {
      public var showSettingSheet: Bool
      @BindingState public var sentence: SentenceStore.State
    }
    
    public enum Action: Equatable, BindableAction {
      case binding(BindingAction<State>)
      case closeSettingSheet(Bool)
      case sentence(SentenceStore.Action)
      case updateLineHeight(CGFloat)
    }
  
  public var body: some ReducerProtocol<State, Action> {
    BindingReducer()
    
    Scope(state: \.sentence, action: /Action.sentence) {
      SentenceStore()
    }
    
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
      case 
      case .closeSettingSheet(let isClose):
        state.showSettingSheet = isClose
        return .none
      case let .updateLineHeight(lineHeight):
        return .run { send in
          await send(.sentence(.updateBaseLineHeight(lineHeight)))
        }
      default:
        return .none
      }
    }
  }
}
