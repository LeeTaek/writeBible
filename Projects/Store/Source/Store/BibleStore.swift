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
    @BindingState public var sentences: IdentifiedArrayOf<SentenceStore.State> = []
    public var settingValue: SettingVO
    public var startCarve: Bool = false
    
    public init(title: BibleTitle, chapter: Int) {
      self.title = title
      self.chapter = chapter
      self.bible = BibleSentenceVO.fetchChapter(title: title.rawValue, chapter: chapter)
      self.settingValue = .defaultValue
      self.bible.forEach {
        self.sentences.insert(SentenceStore.State(sentence: $0), at: $0.section - 1)
      }
    }
  }
  
  public enum Action: BindableAction, Equatable {
    case onAppear
    case binding(BindingAction<State>)
    case sentence(id: SentenceStore.State.ID, action: SentenceStore.Action)
    case fetchSetting(TaskResult<SettingVO>)
//    case showTitle(Bool)
    case startCarve
    case moveToNextChapter(BibleTitle, Int)
    case moveToBeforeChapter(BibleTitle, Int)
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .run { send in
          await send(. fetchSetting(
            TaskResult {
              try await settingRepository.fetch() ?? SettingVO.defaultValue
            }
          ))
        }
      case .sentence(id: let id, action: .onAppear(let sentence)):
        Log.debug("id: \(id), sentence: \(sentence.chapter)")
      case let .fetchSetting(.success(settingVO)):
        state.settingValue = settingVO
      case let .fetchSetting(.failure(error)):
        Log.debug("\(error), set default setting value")
        state.settingValue = SettingVO.defaultValue
      case .moveToNextChapter(state.title, state.chapter):
        break
      case .moveToBeforeChapter(state.title, state.chapter):
        break
      default:
        break
      }
      return .none
      
    }
    .forEach(\.sentences, action: /Action.sentence(id:action:)) {
      SentenceStore()
    }
    ._printChanges()
  }
}
