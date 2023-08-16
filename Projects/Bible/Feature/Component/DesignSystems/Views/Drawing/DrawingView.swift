//
//  DrawingView.swift
//  Bible
//
//  Created by openobject on 2023/08/16.
//  Copyright © 2023 leetaek. All rights reserved.
//

import Store
import SwiftUI

import ComposableArchitecture
import RealmSwift

struct DrawingView: View {
  let store: StoreOf<DrawingStore>
  @ObservedObject var viewStore: ViewStoreOf<DrawingStore>
  
  public init(store: StoreOf<DrawingStore>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  var body: some View {
    VStack {
      GeometryReader { geo in
        ZStack {
          Canvas { context, size in
            for line in viewStore.drawing.writtenData {
              viewStore.send(.line(action: .createPath(
                points: line.linePoints.map { point in
                  CGPoint(x: point.x * geo.size.width,
                          y: point.y * geo.size.height)
                })))
              context.stroke(viewStore.line.path,
                             with: .color(line.lineColor),
                             style: StrokeStyle(lineWidth: line.lineWidth,
                                                lineCap: .round,
                                                lineJoin: .round))
            }
          }
          .gesture(
            DragGesture(minimumDistance: 0, coordinateSpace: .local)
              .onChanged({ value in
                viewStore.send(.positionChanged(location: value.location,
                                                translation: value.translation,
                                                width: geo.size.width,
                                                height: geo.size.height))
              })
              .onEnded({ _ in
                viewStore.send(.lineEnded)
              })
          )
        }
      }
    }
    .background(.clear)
  }
}
