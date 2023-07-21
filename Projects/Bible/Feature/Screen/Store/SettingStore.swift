//
//  SettingStore.swift
//  Bible
//
//  Created by 이택성 on 7/17/23.
//  Copyright © 2023 leetaek. All rights reserved.
//

import Foundation

import ComposableArchitecture

struct SettingStore: ReducerProtocol {
  @Dependency(\.settingRepository) var repository
  
    struct State: Equatable {
      var setting: SettingVO
      var showSettingSheet: Bool
    }
    
    enum Action: Equatable {
        case closeSettingSheet(Bool)
        case baseLineChanged(CGFloat)
        case fontChanged(FontCase)
        case fontSizeChanged(CGFloat)
        case trackingChanged(CGFloat)
        case lineSpaceChanged(CGFloat)
        case updateSetting(SettingVO)
         case saveData(TaskResult<SettingRealmDTO>)
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .closeSettingSheet(let isClose):
            state.showSettingSheet = isClose
            return .none
        case .baseLineChanged(let baseline):
          state.setting.baseLineHeight = baseline
          return .none
        case .fontChanged(let font):
            state.setting.font = font
            return .none
        case .fontSizeChanged(let size):
            state.setting.fontSize = size
            return .none
        case .trackingChanged(let trackingSize):
            state.setting.traking = trackingSize
            return .none
        case .lineSpaceChanged(let lineSpace):
            state.setting.lineSpace = lineSpace
            return .none
        case .updateSetting(let setting):
          return .run { send in
            await send(.saveData(
              TaskResult {
                try await SettingRealmDataSrouce.shared.update(data: setting.toDTO())
              }
            ))
          }
        case let .saveData(.success(settingDto)):
          state.setting = settingDto.toDomain()
          return .send(.closeSettingSheet(true))
        case .saveData(.failure(_)):
          return .send(.closeSettingSheet(true))
        }
    }
    
    
}
