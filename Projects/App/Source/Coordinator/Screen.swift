//
//  Screen.swift
//  Carve
//
//  Created by openobject on 2023/08/10.
//  Copyright © 2023 leetaek. All rights reserved.
//

import Store
import SwiftUI

import ComposableArchitecture

struct Screen: Reducer {
  enum State: Equatable {
    case bible(BibleStore.State)
    case sentence(SentenceStore.State)
    case setting(SettingStore.State)
  }
  
  enum Action {
    case bible(BibleStore.Action)
    case sentence(SentenceStore.Action)
    case setting(SettingStore.Action)
  }
  
  var body: some ReducerOf<Self> {
    Scope(state: /State.bible, action: /Action.bible) {
      BibleStore()
    }
    
    Scope(state: /State.sentence, action: /Action.sentence) {
      SentenceStore()
    }
    
    Scope(state: /State.setting, action: /Action.setting) {
      SettingStore()
    }
  }
  
}
