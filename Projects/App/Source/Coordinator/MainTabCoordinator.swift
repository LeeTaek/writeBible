//
//  Coordinator.swift
//  Carve
//
//  Created by openobject on 2023/08/10.
//  Copyright © 2023 leetaek. All rights reserved.
//

import Foundation

import ComposableArchitecture
import TCACoordinators

struct MainTabCoordinator: Reducer {
  enum Tab: Hashable {
    case write, sentence, setting
  }
  
  struct State: Equatable, IndexedRouterState {
    var routes: [Route<Screen.State>]
  }
  
  enum Action: IndexedRouterAction {
    case routeAction(Int, action: Screen.Action)
    case updateRoutes([Route<Screen.State>])
  }
  
  var body: some ReducerOf<Self> {
    Reduce<State, Action> { state, action in
      switch action {
      case .routeAction(_, .bible(.onAppear)):
        state.routes.presentCover(.bible(.init()), embedInNavigationView: true)
        return .none
      
      default:
        return .none
      }
      
    }
  }
}
