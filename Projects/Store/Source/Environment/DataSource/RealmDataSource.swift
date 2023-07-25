//
//  RealmClient.swift
//  Bible
//
//  Created by openobject on 2023/07/21.
//  Copyright © 2023 leetaek. All rights reserved.
//

import Foundation

import RealmSwift

protocol RealmDataSource {
  associatedtype value
  var realm: Realm? { get }
  var realmQueue: DispatchQueue! { get }
  func create(data: value) async throws
  func read() async throws -> value
  func update(data: value) async throws -> value
  func delete(data: value) async throws

}

extension RealmDataSource {
  public var realm: Realm? {
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

enum RealmObjectError: Error {
  case savedFailure
  case notFoundSettingData
  case updatedFailure
  case deleteFailure
}
