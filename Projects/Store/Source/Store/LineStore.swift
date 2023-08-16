//
//  DrawingStore.swift
//  Store
//
//  Created by openobject on 2023/08/16.
//  Copyright © 2023 leetaek. All rights reserved.
//

import SwiftUI

import ComposableArchitecture
import RealmSwift

public struct LineStore: Reducer {
  public init() { }
  
  public struct State: Equatable {
    public static func == (lhs: LineStore.State, rhs: LineStore.State) -> Bool {
      return lhs.drawing._id == rhs.drawing._id
    }
    
    @ObservedRealmObject public var drawing: WrittenBibleRealmDTO
    public var color: Color
    public var lineWidth: CGFloat
    public var geoSize: CGSize
    public var currentPoints = RealmSwift.List<CGPoint>()
    public var path: Path = Path()
    
    public init(drawing: WrittenBibleRealmDTO, color: Color, lineWidth: CGFloat, geoSize: CGSize) {
      self.drawing = drawing
      self.color = color
      self.lineWidth = lineWidth
      self.geoSize = geoSize
    }
  }
  
  public enum Action: Equatable {
    case createPath(points: [CGPoint])
    case positionChanged(location: CGPoint, translation: CGSize)
    case lineEnded(width: Double, height: Double)
  }
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .createPath(points: let points):
      state.path = createPath(for: points)

    case .positionChanged(location: let location, translation: let translation):
      if translation.width + translation.height == 0 {
        state.currentPoints = RealmSwift.List<CGPoint>()
      }
      state.currentPoints.append(location)
      
    case .lineEnded(width: let width, height: let height):
      if !state.currentPoints.isEmpty {
        let line = Line(points: state.currentPoints,
                        color: state.color,
                        lineWidth: state.lineWidth,
                        xScale: width,
                        yScale: height)
        state.$drawing.writtenData.append(line)
      }
      state.currentPoints = RealmSwift.List<CGPoint>()
    }
    return .none
  }
  
  
  private func createPath(for points: [CGPoint]) -> Path {
    var path = Path()
    
    if let firstPoint = points.first {
      path.move(to: firstPoint)
    }
    if points.count > 1 {
      for index in 1..<points.count {
        let mid = calculateMidPoint(points[index - 1], points[index])
        path.addQuadCurve(to: mid, control: points[index - 1])
      }
    }
    if let last = points.last {
      path.addLine(to: last)
    }
    return path
  }
  
  private func calculateMidPoint(_ point1: CGPoint, _ point2: CGPoint) -> CGPoint {
    let newMidPoint = CGPoint(x: (point1.x + point2.x)/2, y: (point1.y + point2.y)/2)
    return newMidPoint
  }
  
  
}
