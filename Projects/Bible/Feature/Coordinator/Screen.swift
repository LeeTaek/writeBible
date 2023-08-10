//
//  Screen.swift
//  Bible
//
//  Created by openobject on 2023/08/10.
//  Copyright © 2023 leetaek. All rights reserved.
//

import Store
import Foundation

import ComposableArchitecture

struct Screen: Reducer {
  enum State: Equatable, Identifiable {
    case bible(BibleStore.State)
    
    var id: String {
      switch self {
      case .bible(let state):
        return state.title.rawValue + state.chapter.description
      }
    }
  }
  
  enum Action {
    case bible(BibleStore.Action)
  }
  
  var body: some ReducerOf<Self> {
    Scope(state: /State.bible, action: /Action.bible) {
      BibleStore()
    }
  }
  
}
