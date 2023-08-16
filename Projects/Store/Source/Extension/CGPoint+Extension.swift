//
//  CGPoint+Extension.swift
//  Store
//
//  Created by openobject on 2023/08/16.
//  Copyright © 2023 leetaek. All rights reserved.
//

import SwiftUI

import RealmSwift

extension CGPoint: CustomPersistable {
  public typealias PersistedType = PersistablePoint
  
  public init(persistedValue: PersistablePoint) { self.init(x: persistedValue.x, y: persistedValue.y) }
  
  public var persistableValue: PersistablePoint { PersistablePoint(self) }
}



public class PersistablePoint: EmbeddedObject, ObjectKeyIdentifiable {
  @Persisted var x = 0.0
  @Persisted var y = 0.0
  
  convenience init(_ point: CGPoint) {
    self.init()
    self.x = point.x
    self.y = point.y
  }
}
