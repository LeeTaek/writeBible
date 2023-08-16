//
//  InProgressLineView.swift
//  Bible
//
//  Created by openobject on 2023/08/16.
//  Copyright © 2023 leetaek. All rights reserved.
//

import Store
import SwiftUI

import ComposableArchitecture

struct InProgressLineView: View {
  let store: StoreOf<LineStore>
  @ObservedObject var viewStore: ViewStoreOf<LineStore>
  
  public init(store: StoreOf<LineStore>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  var body: some View {
    Canvas { context, size in
      viewStore.send(.createPath(points: Array(viewStore.currentPoints)))
      context.stroke(viewStore.path,
                     with: .color(viewStore.color),
                     style: StrokeStyle(lineWidth: viewStore.lineWidth,
                                        lineCap: .round,
                                        lineJoin: .round))
    }
    .gesture(
      DragGesture(minimumDistance: 0, coordinateSpace: .local)
        .onChanged({ value in
          viewStore.send(.positionChanged(location: value.location,
                                          translation: value.translation))
        })
        .onEnded({ _ in
          viewStore.send(.lineEnded(width: viewStore.geoSize.width,
                                    height: viewStore.geoSize.height))
        })
    )
  }
}

