//
//  Repository.swift
//  Store
//
//  Created by openobject on 2023/07/24.
//  Copyright © 2023 leetaek. All rights reserved.
//

import Foundation

protocol Repository {
  associatedtype value
  func create(data: value) async throws
  func read() async throws -> value
  func update(data: value) async throws -> value
  func delete(data: value) async throws
}
