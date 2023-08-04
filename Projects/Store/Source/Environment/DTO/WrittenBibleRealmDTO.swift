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
  @Persisted public var writtenData: Data?
  @Persisted public var bibleSentence: BibleSentenceVO
  
  public init(writtenData: Data?, bibleSentence: BibleSentenceVO, isWritten: Bool = false) {
    self.writtenData = writtenData
    self.bibleSentence = bibleSentence
  }
  
  public func toStore() -> WrittenSentenceVO {
    return .init(writtenData: writtenData,
                 bible: bibleSentence)
  }
}
