//
//  Coordinator.swift
//  Carve
//
//  Created by openobject on 2023/08/10.
//  Copyright © 2023 leetaek. All rights reserved.
//

import Bible
import Foundation

import ComposableArchitecture
import TCACoordinators

struct MainTabCoordinator: Reducer {
  enum Tab: Hashable {
    case bible, app
  }
  
  struct State: Equatable {
    static let initialState = State(
      bible: .initialState,
      selectedTab: .app
    )
    
    var bible: BibleCoordinator.State
    
    var selectedTab: Tab
  }
  
  enum Action {
    case bible(BibleCoordinator.Action)
    case tabSelected(Tab)
  }
  
  var body: some ReducerOf<Self> {
    Scope(state: \.bible, action: /Action.bible) {
      BibleCoordinator()
    }
    
    Reduce { state, action in
      switch action {
      case .tabSelected(let tab):
        state.selectedTab = tab
      default:
        break
      }
      return .none
    }
  }
}

