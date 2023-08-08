//
//  ContentStore.swift
//  Store
//
//  Created by openobject on 2023/07/31.
//  Copyright © 2023 leetaek. All rights reserved.
//

import Foundation

import ComposableArchitecture

public struct BibleStore: Reducer {
  @Dependency(\.settingRepository) var settingRepository

  public init() { }
  
  public struct State: Equatable {
    public var title = TitleStore.State()
    public var bible: [BibleSentenceVO] = []
    public var sentences: IdentifiedArrayOf<SentenceStore.State> = []
    public var settingValue: SettingVO = .defaultValue
    public var startCarve: Bool = false
    public init() { }
  }
  
  public enum Action: Equatable {
    case onAppear
    case titleAction(TitleStore.Action)
    case sentence(id: SentenceStore.State.ID, action: SentenceStore.Action)
    case fetchSetting(TaskResult<SettingVO>)
    case showSettingSheet(Bool)
    case showTitle(Bool)
    case startCarve
  }
  
  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        state.bible = BibleSentenceVO.fetchChapter(title: state.title.bibleTitle.rawValue,
                                                       chapter: state.title.chapter)
        state.bible.forEach {
          state.sentences.insert(SentenceStore.State(id: UUID(), sentence: $0), at: $0.chapter - 1)
        }
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
      case let .showSettingSheet(isShow):
        return .send(.titleAction(.showSettingSheet(isShow)))
      case let .showTitle(isShow):
        return .send(.titleAction(.showTitle(isShow)))
      case .startCarve:
        return .none

      default:
        return .none

      }
      
    }
    .forEach(\.sentences, action: /Action.sentence(id:action:)) {
     SentenceStore()
        ._printChanges()
    }
//    ._printChanges()
  }
}
