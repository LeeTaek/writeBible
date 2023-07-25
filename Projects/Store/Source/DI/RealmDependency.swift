//
//  RealmDependency.swift
//  Carve
//
//  Created by openobject on 2023/07/25.
//  Copyright © 2023 leetaek. All rights reserved.
//

import Foundation

protocol RealmDependency {
  associatedtype value
  var fetch: @Sendable () async throws -> value { get }
  var update: @Sendable (value) async throws -> value { get }
}
