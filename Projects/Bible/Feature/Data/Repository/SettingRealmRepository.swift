//
//  SettingRealmRepository.swift
//  Bible
//
//  Created by openobject on 2023/07/20.
//  Copyright © 2023 leetaek. All rights reserved.
//

import Foundation

import RealmSwift

public protocol RealmRepository {
  associatedtype value
  var realm: Realm? { get }
  var realmQueue: DispatchQueue! { get }
  func create(data: value) async throws -> value
  func read(data: value) async throws
  func update(data: value) async throws
  func delete(data: value) async throws
}

extension RealmRepository {
  var realm: Realm? {
    do {
      let realm = try Realm()
      Log.debug("📂\(self)'s file UTL: \(String(describing: realm.configuration.fileURL))")
      return realm
    } catch {
      print("Error initiating new realm \(error)")
      return nil
    }
  }
  
  var realmQueue: DispatchQueue! {
    return DispatchQueue(label: "realm-queue")
  }
}

struct SettingRealmRepository: RealmRepository {
  typealias value = SettingRealmObject
  
  var realm: Realm!
  var realmQueue: DispatchQueue!
  
  func create(data: SettingRealmObject) async throws -> SettingRealmObject {
    <#code#>
  }
  
  func read(data: SettingRealmObject) async throws {
    <#code#>
  }
  
  func update(data: SettingRealmObject) async throws {
    <#code#>
  }
  
  func delete(data: SettingRealmObject) async throws {
    <#code#>
  }
  
}

class SettingRealmObject: Object {
  
}

