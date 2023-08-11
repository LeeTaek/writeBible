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
    WithViewStore(store, observe: \.selectedTab) { viewStore in
    TabView(selection: viewStore.binding(get: { $0 },
                                         send: MainTabCoordinator.Action.tabSelected )) {
      BibleCoordinatorView(
        store: store.scope(
          state: { $0.bible },
          action: { .bible($0) }
        )
      )
      .tabItem{ Text("bible") }
      .tag(MainTabCoordinator.Tab.bible)
    }
    }
  }
  
}
