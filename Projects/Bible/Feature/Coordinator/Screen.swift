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

public struct Screen: Reducer {
  public enum State: Equatable, Identifiable {
    case bible(BibleStore.State)
    case titleSheet(TitleStore.State)
    case settingSheet(SettingStore.State)
    
    public var id: String {
      switch self {
      case .bible(let state):
        return state.title.rawValue + state.chapter.description
      case .titleSheet(let state):
        return state.id.uuidString
      case .settingSheet(let state):
        return state.id.uuidString
      }
    }
  }
  
  public enum Action {
    case bible(BibleStore.Action)
    case titleSheet(TitleStore.Action)
    case settingSheet(SettingStore.Action)
  }
  
  public var body: some ReducerOf<Self> {
    Scope(state: /State.bible, action: /Action.bible) {
      BibleStore()
    }
    Scope(state: /State.titleSheet, action: /Action.titleSheet) {
      TitleStore()
    }
    Scope(state: /State.settingSheet, action: /Action.settingSheet) {
      SettingStore()
    }
  }
  
}
