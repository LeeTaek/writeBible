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
        var setting: SettingModel
        var showSettingSheet: Bool
        var settingManager: SettingManager
    }
    
    enum Action: Equatable {
        case closeSettingSheet(Bool)
        case fontChanged(FontCase)
        case fontSizeChanged(CGFloat)
        case trackingChanged(CGFloat)
        case lineSpaceChanged(CGFloat)
        case updateSetting(Bool)
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .closeSettingSheet(let isClose):
            state.showSettingSheet = isClose
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
