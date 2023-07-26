//
//  WrittenBibleRealmDTO.swift
//  Store
//
//  Created by openobject on 2023/07/25.
//  Copyright © 2023 leetaek. All rights reserved.
//

import Foundation

import RealmSwift

public class WrittenBibleRealmDTO: Object {
  @Persisted public var id = UUID()
  @Persisted public var writtenData: Data
  @Persisted public var bibleSentence: BibleVO
  @Persisted public var isWritten: Bool
  
  public init(writtenData: Data, bibleSentence: BibleVO, isWritten: Bool = false) {
    self.writtenData = writtenData
    self.bibleSentence = bibleSentence
    self.isWritten = isWritten
  }
  
  public func toStore() -> WrittenBibleVO {
    return .init(writtenData: writtenData,
                 bible: bibleSentence,
                 isWrite: true)
  }
}
