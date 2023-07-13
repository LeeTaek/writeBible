//
//  AppCoordinator.swift
//  Carve
//
//  Created by openobject on 2023/07/13.
//  Copyright © 2023 leetaek. All rights reserved.
//

import ComposableArchitecture
import TCACoordinators

//struct Coordinator: ReducerProtocol {
//  struct State: Equatable, IndexedRouterState {
//     var routes: [Route<Screen.State>]
//   }
//  
//  enum Action: IndexedRouterAction {
//    case routeAction(Int, action: Screen.Action)
//    case updateRoutes(_ screens: [Route<Screen>])
//  }
//  
//
//  var body: some ReducerProtocol<State, Action> {
//    return Reduce<State, Action> { state, action in
//      switch action {
//      case .routeAction(_, .home(.startTapped)):
//        state.routes.presentSheet(.numbersList(.init(numbers: Array(0 ..< 4))), embedInNavigationView: true)
//        
//      case .routeAction(_, .numbersList(.numberSelected(let number))):
//        state.routes.push(.numberDetail(.init(number: number)))
//        
//      case .routeAction(_, .numberDetail(.showDouble(let number))):
//        state.routes.presentSheet(.numberDetail(.init(number: number * 2)))
//        
//      case .routeAction(_, .numberDetail(.goBackTapped)):
//        state.routes.goBack()
//        
//      case .routeAction(_, .numberDetail(.goBackToNumbersList)):
//        return .routeWithDelaysIfUnsupported(state.routes) {
//          $0.goBackTo(/Screen.State.numbersList)
//        }
//        
//      case .routeAction(_, .numberDetail(.goBackToRootTapped)):
//        return .routeWithDelaysIfUnsupported(state.routes) {
//          $0.goBackToRoot()
//        }
//        
//      default:
//        break
//      }
//      return .none
//    }.forEachRoute {
//      Screen()
//    }
//  }
//}
