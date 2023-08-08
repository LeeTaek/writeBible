//
//  RouterView.swift
//  Carve
//
//  Created by openobject on 2023/08/08.
//  Copyright © 2023 leetaek. All rights reserved.
//

import Bible
import SwiftUI

import ComposableArchitecture

struct RouterView: View {
  let store: StoreOf<Router>
  @ObservedObject var viewStore: ViewStoreOf<Router>
  
  init(store: StoreOf<Router>) {
    self.store = store
    self.viewStore = ViewStore(store, observe: { $0 })
  }
  
  
  var body: some View {
    Bible.BibleView(
      store: self.store.scope(state: \.bible, action: Router.Action.bible)
    )
    .onAppear {
      self.store.send(.onAppear)
    }
  }
}
