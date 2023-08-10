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
    public var title: BibleTitle
    public var chapter: Int
    public var bible: [BibleSentenceVO] = []
//    public var titleState: TitleStore.State
    @BindingState public var sentences: IdentifiedArrayOf<SentenceStore.State> = []
    public var settingValue: SettingVO = .defaultValue
    public var startCarve: Bool = false
    
    public init(title: BibleTitle, chapter: Int) {
      self.title = title
      self.chapter = chapter
    }
  }
  
  public enum Action: BindableAction, Equatable {
    case onAppear
    case binding(BindingAction<State>)
//    case titleAction(TitleStore.Action)
    case sentence(id: SentenceStore.State.ID, action: SentenceStore.Action)
    case fetchSetting(TaskResult<SettingVO>)
//    case showSettingSheet(Bool)
//    case showTitle(Bool)
    case startCarve
    case moveToNextChapter
    case moveToBeforeChapter
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .onAppear:
        state.bible = BibleSentenceVO.fetchChapter(title: state.title.rawValue,
                                                   chapter: state.chapter)
        state.sentences.append(contentsOf: state.bible.map {
                  SentenceStore.State(sentence: $0)
        })
        return .run { send in
          await send(. fetchSetting(
            TaskResult {
              try await settingRepository.fetch() ?? SettingVO.defaultValue
            }
          ))
        }
      case .sentence(id: let id, action: .onAppear(let sentence)):
        Log.debug("id: \(id), sentence: \(sentence.chapter)")
        return .none
      case let .fetchSetting(.success(settingVO)):
        state.settingValue = settingVO
        return .none
      case let .fetchSetting(.failure(error)):
        Log.debug("\(error), set default setting value")
        state.settingValue = SettingVO.defaultValue
        return .none
      case .moveToNextChapter:
        let lastChapter = BibleSentenceVO.lastChapter(title: state.title.rawValue)
        if state.chapter < lastChapter {
          state.chapter += 1
        } else if state.title != .revelation {
          state.title = state.title.next()
          state.chapter = 1
        }
        return .none
      case .moveToBeforeChapter:
        let lastChapter = BibleSentenceVO.lastChapter(title: state.title.rawValue)
        if state.chapter > 1 {
          state.chapter -= 1
        } else if state.title != .genesis {
          state.title = state.title.before()
          state.chapter = lastChapter
        }
        return .none
      case .startCarve:
        return .none

      default:
        return .none

      }
      
    }
    .forEach(\.sentences, action: /Action.sentence(id:action:)) {
      SentenceStore()
    }
//    ._printChanges()
  }
}
