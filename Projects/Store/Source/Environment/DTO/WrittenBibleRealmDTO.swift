//
//  WrittenBibleRealmDTO.swift
//  Store
//
//  Created by openobject on 2023/07/25.
//  Copyright © 2023 leetaek. All rights reserved.
//

import SwiftUI

import RealmSwift

public class WrittenBibleRealmDTO: Object, ObjectKeyIdentifiable {
  @Persisted(primaryKey: true) public var _id: ObjectId
  @Persisted public var writtenData = RealmSwift.List<Line>()
  @Persisted public var bibleSentence: BibleSentenceVO
  
  public convenience init(bibleSentence: BibleSentenceVO, isWritten: Bool = false) async {
    self.init()
    self.bibleSentence = bibleSentence
  }
  
  public func clear() {
    writtenData = RealmSwift.List<Line>()
  }
  
  public func toStore() -> WrittenSentenceVO {
    return .init(writtenData: writtenData,
                 bible: bibleSentence)
  }
}



public class Line: EmbeddedObject, ObjectKeyIdentifiable {
  @Persisted public var lineColor: Color
  @Persisted public var lineWidth: CGFloat = 5.0
  @Persisted public var linePoints = RealmSwift.List<CGPoint>()
}

extension Line {
  
  convenience init (point: CGPoint, color: Color, lineWidth: CGFloat) {
    self.init()
    self.linePoints.append(point)
    self.lineColor = color
    self.lineWidth = lineWidth
  }
  
  convenience init (points: RealmSwift.List<CGPoint>, color: Color, lineWidth: CGFloat, xScale: CGFloat, yScale: CGFloat) {
    self.init()
    self.linePoints = points
    self.lineColor = color
    self.lineWidth = lineWidth
  }
}

