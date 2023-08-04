//
//  ContentStore.swift
//  Store
//
//  Created by openobject on 2023/07/31.
//  Copyright © 2023 leetaek. All rights reserved.
//

import Foundation

import ComposableArchitecture

public struct ContentStore: ReducerProtocol {
  @Dependency(\.settingRepository) var settingRepository

  public struct State: Equatable {
    public var title = TitleStore.State()
    public var sentences: [BibleSentenceVO]
    public var settingValue: SettingVO
    public var startCarve: Bool = false
  }
  
  public enum Action: Equatable {
    case onAppear
    case titleAction(TitleStore.Action)
    case fetchSetting(TaskResult<SettingVO>)
    case showSettingSheet
    case showTitle
    case startCarve
  }
  
  public var body: some ReducerProtocol<State, Action> {
    Scope(state: \.title, action: /Action.titleAction) {
      TitleStore()
        ._printChanges()
    }
    
    Reduce { state, action in
      switch action {
      case .onAppear:
        state.sentences = BibleSentenceVO.fetchChapter(title: state.title.bibleTitle.rawValue,
                                                       chapter: state.title.chapter)
        return .run { send in
          await send(. fetchSetting(
            TaskResult {
              try await settingRepository.fetch() ?? SettingVO.defaultValue
            }
          ))
        }
      case let .fetchSetting(.success(settingVO)):
        state.settingValue = settingVO
        return .none
      case let .fetchSetting(.failure(error)):
        Log.debug("\(error), set default setting value")
        state.settingValue = SettingVO.defaultValue
        return .none
      case .showSettingSheet:
        return .send(.titleAction(.toggleShowSettingSheet))
      case .showTitle:
        return .send(.titleAction(.toggleShowTitle))
      case .startCarve:
        return .none

      default:
        return .none

      }
    }
    ._printChanges()
  }
}
