//
//  Color+Extension.swift
//  Store
//
//  Created by openobject on 2023/08/16.
//  Copyright © 2023 leetaek. All rights reserved.
//

import SwiftUI

import RealmSwift

extension Color: CustomPersistable {
  public typealias PersistedType = PersistableColor
  
  public init(persistedValue: PersistableColor) { self.init(
    .sRGB, red: persistedValue.red,
    green: persistedValue.green,
    blue: persistedValue.blue,
    opacity: persistedValue.opacity) }
  
  public var persistableValue: PersistableColor {
    PersistableColor(color: self)
  }
}


public class PersistableColor: EmbeddedObject {
  @Persisted var red: Double = 0
  @Persisted var green: Double = 0
  @Persisted var blue: Double = 0
  @Persisted var opacity: Double = 0
  
  convenience init(color: Color) {
    self.init()
    if let components = color.cgColor?.components {
      if components.count >= 3 {
        red = components[0]
        green = components[1]
        blue = components[2]
      }
      if components.count >= 4 {
        opacity = components[3]
      }
    }
  }
}
