//
//  Router.swift
//  Carve
//
//  Created by openobject on 2023/08/08.
//  Copyright © 2023 leetaek. All rights reserved.
//

import Store
import Foundation

import ComposableArchitecture

struct Router: Reducer {
  struct State: Equatable{
    var bible = BibleStore.State()
    var sentence = SentenceStore.State(id: UUID(), sentence: BibleSentenceVO.defaultValue)
  }
  
  enum Action: Equatable {
    case onAppear
    case bible(BibleStore.Action)
    case sentence(SentenceStore.Action)
  }
  
  var body: some Reducer<State, Action> {
    Scope(state: \.bible, action: /Action.bible) {
      BibleStore()
    }
    
    Scope(state: \.sentence, action: /Action.sentence) {
      SentenceStore()
    }
    
    Reduce { state, action in
      switch action {
      case .onAppear:
        state = .init()
        return .none
      default:
        return .none
      }
    }
  }
  
}
