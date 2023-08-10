//
//  CoordinatorView.swift
//  Carve
//
//  Created by openobject on 2023/07/13.
//  Copyright © 2023 leetaek. All rights reserved.
//

import Bible
import SwiftUI

import ComposableArchitecture
import TCACoordinators

struct MainTabCoordinatorView: View {
  let store: StoreOf<MainTabCoordinator>
  
  var body: some View {
    TCARouter(store) { screen in
      SwitchStore(screen) { screen in
        switch screen {
        case .bible:
          CaseLet(
            /Screen.State.bible,
             action: Screen.Action.bible,
             then: BibleView.init
          )
          
        case .sentence:
          CaseLet(
            /Screen.State.sentence,
             action: Screen.Action.sentence,
             then: BibleSentenceView.init
          )
        }
      }
    }
  }
  
}
