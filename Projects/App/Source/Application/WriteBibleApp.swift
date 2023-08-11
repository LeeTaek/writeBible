//
//  WriteBibleApp.swX
//
//  Created by 이택성 on 2022/06/02.
//

import Bible
import Store
import SwiftUI

import ComposableArchitecture

@main
struct WriteBibleApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  
  var body: some Scene {
    WindowGroup {
//      MainTabCoordinatorView(
//        store: Store(initialState: .initialState, reducer: {
//          MainTabCoordinator()
//        })
//      )
      BibleCoordinatorView(store: Store(initialState: .initialState) {
          BibleCoordinator()
        })
      
//      BibleView(store: Store(initialState: BibleStore.State(title: .genesis, chapter: 1)) {
//        BibleStore()
//      })
    }
  }
}

