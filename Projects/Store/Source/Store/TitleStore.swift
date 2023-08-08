//
//  TitleStore.swift
//  Store
//
//  Created by openobject on 2023/08/03.
//  Copyright © 2023 leetaek. All rights reserved.
//

import Foundation

import ComposableArchitecture

public struct TitleStore: Reducer {
  @Dependency(\.latestWrittenChapterRepository) var latestWrittenChapterRepository
  
  public init() { }
  
  public struct State: Equatable {
    public var bibleTitle: BibleTitle = .genesis
    public var chapter: Int = 1
    public var lastChapter: Int = 1
    public var showTitleSheet: Bool = false
    public var showTitle: Bool = false
    public var showSettingSheet: Bool = false
    
    public init() { }
  }
  
  public enum Action: Equatable {
    case onAppear
    case fetchLatestChapter(TaskResult<LatestWrittenChapterVO>)
    case showTitleSheet(Bool)
    case showSettingSheet(Bool)
    case showTitle(Bool)
    case selectTitle(BibleTitle)
    case selectChapter(Int)
    case moveTo(title: BibleTitle, chapter: Int)
    case updateLatestChapter(TaskResult<LatestWrittenChapterVO>)
  }
  
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .onAppear:
      return .run { send in
        await send( .fetchLatestChapter(
          TaskResult {
            try await latestWrittenChapterRepository.fetch() ?? LatestWrittenChapterVO(title: "창세기", chapter: 1)
          }
        ))
      }
    case let .fetchLatestChapter(.success(latest)):
      state.bibleTitle = BibleTitle(rawValue: latest.title)!
      state.chapter = latest.chapter
      return .none
    case let .showTitleSheet(isShow):
      state.showTitleSheet = isShow
      return .none
    case let .showSettingSheet(isShow):
      state.showSettingSheet = isShow
      return .none
    case let .showTitle(isShow):
      state.showTitle = isShow
      return .none
    case .selectTitle(let title):
      state.bibleTitle = title
      state.lastChapter = BibleSentenceVO.lastChapter(title: title.rawValue)
      return .none
    case .selectChapter(let chapter):
      state.chapter = chapter
      let latest = LatestWrittenChapterVO(title: state.bibleTitle.rawValue, chapter: state.chapter)
      return .run { send in
        await send(.updateLatestChapter(
          TaskResult {
            try await latestWrittenChapterRepository.update(latest)
          }
        ))
      }
    case let .updateLatestChapter(.success(updatedData)):
      Log.debug("updated latest wirtten bible: \(updatedData)")
      return .send(.showSettingSheet(false))
    case .moveTo(title: let title, chapter: let chapter):
      state.bibleTitle = title
      state.chapter = chapter
      state.lastChapter = BibleSentenceVO.lastChapter(title: title.rawValue)
      let latest = LatestWrittenChapterVO(title: state.bibleTitle.rawValue, chapter: state.chapter)
      return .run { send in
        await send(.updateLatestChapter(
          TaskResult {
            try await latestWrittenChapterRepository.update(latest)
          }
        ))
      }
    default:
      return .none
    }
  }
  
}
