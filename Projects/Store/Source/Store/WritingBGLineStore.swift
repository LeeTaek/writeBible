//
//  WritingBGLineStore.swift
//  Store
//
//  Created by openobject on 2023/07/26.
//  Copyright © 2023 leetaek. All rights reserved.
//

import Foundation

import ComposableArchitecture

public struct WritingBGLineStore: ReducerProtocol {
  
  public struct State: Equatable {
    public var textHeight: CGFloat
    public var line: Int
    public var sentence: SentenceStore.State
  }
  
  public enum Action: Equatable {
    case calculateLine(CGFloat)
    
  }
  
  public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action{
    case let .calculateLine(textHeight):
      let lineHeight =
      state.textHeight = textHeight

      return .none
    }
  }
}
