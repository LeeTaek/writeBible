//
//  RealmRepository.swift
//  Bible
//
//  Created by openobject on 2023/07/21.
//  Copyright © 2023 leetaek. All rights reserved.
//

import Foundation

import RealmSwift

public protocol RealmRepository {
  associatedtype value
  var fetch: @Sendable () async throws -> value { get }
}
