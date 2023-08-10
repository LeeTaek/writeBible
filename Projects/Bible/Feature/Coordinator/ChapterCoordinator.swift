//
//  Coordinator.swift
//  ProjectDescriptionHelpers
//
//  Created by openobject on 2023/07/12.
//

import Store
import Foundation

import ComposableArchitecture
import TCACoordinators

struct ChapterCoordinator: Reducer {
  struct State: Equatable, IdentifiedRouterState {
    static let initialState = State(
      routes: [.root(.bible(.init(title: .genesis, chapter: 1)), embedInNavigationView: true)]
    )

    var routes: IdentifiedArrayOf<Route<Screen.State>>
  }
  
  enum Action: IdentifiedRouterAction {
    case routeAction(Screen.State.ID, action: Screen.Action)
    case updateRoutes(IdentifiedArrayOf<Route<Screen.State>>)
  }
  
  var body: some ReducerOf<Self> {
    Reduce<State, Action> { state, action in
      switch action {
      case .routeAction(_, action: .bible(.moveToNextChapter(let title, let chapter))):
        let lastChapter = BibleSentenceVO.lastChapter(title: title.rawValue)
        if chapter < lastChapter {
          state.routes.presentCover(.bible(.init(title: title, chapter: chapter + 1)))
        } else if title != .revelation {
          state.routes.presentCover(.bible(.init(title: title.next(), chapter: 1)))
        }
      case .routeAction(_, action: .bible(.moveToBeforeChapter(let title, let chapter))):
        let lastChapter = BibleSentenceVO.lastChapter(title: title.rawValue)
        if chapter > 1 {
          state.routes.presentCover(.bible(.init(title: title, chapter: chapter - 1)))
        } else if title != .genesis {
          state.routes.presentCover(.bible(.init(title: title.before(), chapter: lastChapter)))
        }
      default:
        break
      }
      return .none
    }
  }
  
}
