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

public struct DrawingStore: Reducer {
  public init() { }
  
  public struct State: Equatable {
    public static func == (lhs: DrawingStore.State, rhs: DrawingStore.State) -> Bool {
      return lhs.sentence.title == rhs.sentence.title &&
      lhs.sentence.chapter == rhs.sentence.chapter &&
      lhs.sentence.section == rhs.sentence.section
    }
    
    @ObservedRealmObject public var drawing: WrittenBibleRealmDTO
    @AppStorage("delayPersistance") public var delayPersistance = false
    var sentence: BibleSentenceVO
    var selectedColor: Color = .black
    var selectedLineWidth: CGFloat = 1
    var currentPoints: [CGPoint] = []
    public var line: LineStore.State
    
    public init(drawing: WrittenBibleRealmDTO, sentence: BibleSentenceVO, line: LineStore.State) {
      self.drawing = drawing
      self.sentence = sentence
      self.line = line
    }
  }
  
  public enum Action: Equatable {
    case line(action: LineStore.Action)
    case undoDrawing
    case positionChanged(location: CGPoint, translation: CGSize, width: Double, height: Double)
    case lineEnded
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .positionChanged(location: let location, translation: let translation, width: let width, height: let height):
        let newPoint = CGPoint(x: location.x / width, y: location.y / height)
        if translation.width + translation.height == 0 {
          if !state.delayPersistance {
            let line = Line(point: newPoint, color: state.selectedColor, lineWidth: state.selectedLineWidth)
            state.$drawing.writtenData.append(line)
          }
        } else {
          let index = state.drawing.writtenData.count - 1
          if !state.delayPersistance {
            state.$drawing.writtenData[index].linePoints.append(newPoint)
          }
        }
      case .lineEnded:
        if !state.delayPersistance {
          if let last = state.drawing.writtenData.last?.linePoints, last.isEmpty {
            state.$drawing.writtenData.wrappedValue.removeLast()
          }
        }
      default:
        break
      }
      return .none
    }
    
  }
}

