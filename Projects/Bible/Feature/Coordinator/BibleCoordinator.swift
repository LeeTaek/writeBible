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

public struct BibleCoordinator: Reducer {
  @Dependency(\.latestWrittenChapterRepository) var latestWrittenChapterRepository

  public init() { }
  
  public struct State: Equatable, IdentifiedRouterState {
    public static let initialState = State(
      routes: [.root(.bible(.init(title: .genesis, chapter: 1)))]
    )
    
    public var routes: IdentifiedArrayOf<Route<Screen.State>>
  }
  
  public enum Action: IdentifiedRouterAction {
    case routeAction(Screen.State.ID, action: Screen.Action)
    case updateRoutes(IdentifiedArrayOf<Route<Screen.State>>)
    
    case onAppear
    case fetchLatestChapter(TaskResult<LatestWrittenChapterVO>)
    case update(BibleTitle, Int)
    case updateLatestChapter(TaskResult<LatestWrittenChapterVO>)
  }
  
  public var body: some ReducerOf<Self> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onAppear:
        return .run { send in
          await send( .fetchLatestChapter(
            TaskResult {
              try await latestWrittenChapterRepository.fetch() ?? .defaultValue
            }
          ))
        }
      case let .fetchLatestChapter(.success(latest)):
        Log.debug(latest)
        state.routes.presentCover(.bible(.init(title: latest.title, chapter: latest.chapter)))
      case .update(let title, let chapter):
        let latest = LatestWrittenChapterVO(title: title, chapter: chapter)
        return .run { send in
          await send (.updateLatestChapter(
            TaskResult {
              try await latestWrittenChapterRepository.update(latest)
            }
          ))
        }
      case let .updateLatestChapter(.success(latestChapter)):
        Log.debug("success update: \(latestChapter.title.rawValue), \(latestChapter.chapter)")
      case .routeAction(_, action: .bible(.moveToNextChapter(let title, let chapter))):
        let lastChapter = BibleSentenceVO.lastChapter(title: title.rawValue)
        if chapter < lastChapter {
          state.routes.presentCover(.bible(.init(title: title, chapter: chapter + 1)))
          return .send(.update(title, chapter + 1))
        } else if title != .revelation {
          state.routes.presentCover(.bible(.init(title: title.next(), chapter: 1)))
          return .send(.update(title.next(), 1))
        }
      case .routeAction(_ , action: .bible(.moveToBeforeChapter(let title, let chapter))):
        let lastChapter = BibleSentenceVO.lastChapter(title: title.rawValue)
        if chapter > 1 {
          state.routes.presentCover(.bible(.init(title: title, chapter: chapter - 1)))
          return .send(.update(title, chapter - 1))
        } else if title != .genesis {
          state.routes.presentCover(.bible(.init(title: title.before(), chapter: lastChapter)))
          return .send(.update(title.before(), lastChapter))
        }
      case .routeAction(_, action: .titleSheet(.showTitleSheet)):
        state.routes.presentSheet(.titleSheet(.init()))
      case .routeAction(_, action: .titleSheet(.moveTo(title: let title, chapter: let chapter))):
        state.routes.presentCover(.bible(.init(title: title, chapter: chapter)))
        return .send(.update(title, chapter))
      case .routeAction(_, action: .titleSheet(.showSettingSheet)):
        state.routes.presentSheet(.settingSheet(.init()))
      default:
        break
      }
      return .none
    }
    .forEachRoute {
      Screen()
    }
    ._printChanges()
  }
  
}
