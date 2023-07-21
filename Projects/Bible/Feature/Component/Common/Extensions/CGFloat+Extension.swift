//
//  CGFloat+Extension.swift
//  Bible
//
//  Created by openobject on 2023/07/21.
//  Copyright © 2023 leetaek. All rights reserved.
//

import UIKit

import RealmSwift

extension CGFloat: CustomPersistable {
  public typealias PersistedType = Double
  public init(persistedValue: Double) { self.init(persistedValue) }
  public var persistableValue: Double { Double(self) }
  
  
}
