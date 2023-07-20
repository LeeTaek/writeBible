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
    struct State: Equatable {
      @BindingState var setting: SettingModel
      @BindingState var showSettingSheet: Bool
      @BindingState var settingManager: SettingManager
    }
    
    enum Action: Equatable {
      case binding(BindingAction<State>)
        case closeSettingSheet(Bool)
        case baseLineChanged(CGFloat)
        case fontChanged(FontCase)
        case fontSizeChanged(CGFloat)
        case trackingChanged(CGFloat)
        case lineSpaceChanged(CGFloat)
        case updateSetting(Bool)
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .binding:
          return .none
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
        case .updateSetting(let isUpdate):
            state.settingManager.updateSetting(setting: state.setting)
            state.showSettingSheet = isUpdate
            return .none
        }
    }
    
    
}
