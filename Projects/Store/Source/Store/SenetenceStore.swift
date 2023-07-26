//
//  SenetenceStore.swift
//  Store
//
//  Created by openobject on 2023/07/26.
//  Copyright © 2023 leetaek. All rights reserved.
//

import Foundation

import ComposableArchitecture

public struct SentenceStore: ReducerProtocol {
  @Dependency(\.settingRepository) var repository
  
  public struct State: Equatable {
    public var bible: [BibleVO]
    public var setting: SettingVO
  }
  
  public enum Action: Equatable {
    case fetchBible(title: String)
    case initSetting
    case fetchSetting(TaskResult<SettingVO>)
    case updateSetting(SettingVO)
    case updateSettingResponse(TaskResult<SettingVO>)
    case updateBaseLineHeight(CGFloat)
  }
  
  
  public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case .fetchBible(title: let title):
      state.bible = BibleVO.fetchBible(title: title)
      return .none
    case .initSetting:
      return .run { send in
        await send(.fetchSetting(
          TaskResult {
            try await repository.fetch()
          }
        ))
      }
    case let .fetchSetting(.success(settingVO)):
      state.setting = settingVO
      return .none
    case let .fetchSetting(.failure(error)):
      Log.debug("\(error), set default setting value")
      state.setting = SettingVO.defaultValue
      return .none
    case .updateSetting(let setting):
      return .run { send in
        await send(.updateSettingResponse(
          TaskResult {
            try await repository.update(setting)
          }
        ))
      }
    case let .updateSettingResponse(.success(settingVO)):
      state.setting = settingVO
      return .none
    case .updateSettingResponse(.failure(_)):
      return .none
    case let .updateBaseLineHeight(lineHeight):
      state.setting.baseLineHeight = lineHeight
      return .none
    }
  }
  
}
