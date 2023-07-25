//
//  SettingStore.swift
//  Bible
//
//  Created by 이택성 on 7/17/23.
//  Copyright © 2023 leetaek. All rights reserved.
//

import Foundation

import ComposableArchitecture

public struct SettingStore: ReducerProtocol {
  @Dependency(\.settingRepository) var repository
  
    public struct State: Equatable {
      @BindingState public var setting: SettingVO
      public var showSettingSheet: Bool
    }
    
    public enum Action: Equatable, BindableAction {
      case binding(BindingAction<State>)
      case fetch
      case _fetchResponse(TaskResult<SettingVO>)
      case updateSetting(SettingVO)
      case baseLineChanged(CGFloat)
      case _updateSettingResponse(TaskResult<SettingVO>)
      case closeSettingSheet(Bool)

    }
  
  public var body: some ReducerProtocol<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
      case .fetch:
        return .run { send in
          await send(._fetchResponse(
            TaskResult {
              try await repository.fetch()
            }
          ))
        }
      case let ._fetchResponse(.success(settingVO)):
        state.setting = settingVO
        return .none
      case let ._fetchResponse(.failure(error)):
        Log.debug(error)
        state.setting = SettingVO.defaultValue
        return .none
      case .updateSetting(let setting):
        return .run { send in
          await send(._updateSettingResponse(
            TaskResult {
              try await repository.update(setting)
            }
          ))
        }
      case let ._updateSettingResponse(.success(settingVO)):
        state.setting = settingVO
        return .send(.closeSettingSheet(true))
      case let .baseLineChanged(lineHeight):
        state.setting.baseLineHeight = lineHeight
        return .none
      case ._updateSettingResponse(.failure(_)):
        return .send(.closeSettingSheet(true))
      case .closeSettingSheet(let isClose):
          state.showSettingSheet = isClose
          return .none

      }
    }
  }
}
