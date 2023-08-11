//
//  BibleCoordinatorView.swift
//  Bible
//
//  Created by openobject on 2023/08/11.
//  Copyright © 2023 leetaek. All rights reserved.
//

import Store
import SwiftUI

import ComposableArchitecture
import TCACoordinators

public struct BibleCoordinatorView: View {
  let store: StoreOf<BibleCoordinator>
  
  public init(store: StoreOf<BibleCoordinator>) {
    self.store = store
  }
  
  public var body: some View {
    TCARouter(store) { screen in
      SwitchStore(screen) { screen in
        switch screen {
        case .bible:
         CaseLet(
          /Screen.State.bible,
           action: Screen.Action.bible,
           then: BibleView.init
         )
         .onAppear {
           store.send(.onAppear)
         }
          
        case .titleSheet:
          CaseLet(
            /Screen.State.titleSheet,
             action: Screen.Action.titleSheet,
             then: TitleView.init
          )
          
        case .settingSheet:
          CaseLet(
            /Screen.State.settingSheet,
             action: Screen.Action.settingSheet,
             then: SettingView.init
          )
        }
      }
    }
  }
}
