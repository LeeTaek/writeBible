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
  
  public init() { }
  
  public struct State: Equatable {
    public var id = UUID()
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
    case showTitleSheet
    case showSettingSheet
    case showTitle(Bool)
    case selectTitle(BibleTitle)
    case selectChapter(Int)
    case moveTo(title: BibleTitle, chapter: Int)
    case updateLatestChapter(TaskResult<LatestWrittenChapterVO>)
  }
  
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .onAppear:
      break
    case let .showTitle(isShow):
      state.showTitle = isShow
    case .selectTitle(let title):
      state.bibleTitle = title
      state.lastChapter = BibleSentenceVO.lastChapter(title: title.rawValue)
    case .selectChapter(let chapter):
      state.chapter = chapter
      return .send(.moveTo(title: state.bibleTitle, chapter: state.chapter))
    case let .updateLatestChapter(.success(updatedData)):
      Log.debug("updated latest wirtten bible: \(updatedData)")
      return .send(.showSettingSheet)
    default:
      break
    }
    return .none
  }
  
}
