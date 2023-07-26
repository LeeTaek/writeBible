//
//  WrittenBibleVO.swift
//  Store
//
//  Created by openobject on 2023/07/25.
//  Copyright © 2023 leetaek. All rights reserved.
//

import Foundation

import RealmSwift

public struct BibleVO: Hashable {
  public var title: String
  public var chapter: Int
  public var section: Int
  public var chapterTitle: String?
  public var sentence: String
  
  static public let defaultValue = Self(
    title: "요한계시록",
    chapter: 4,
    section: 1,
    sentence: "이 일 후에 내가 보니 하늘에 열린 문이 있는데 내가 들은 바 처음에 내게 말하던 나팔 소리 같은 그 음성이 이르되 이리로 올라오라 이 후에 마땅히 일어날 일들을 내가 네게 보이리라 하시더라"
  )
  
  static func fetchBible(title: String) -> [Self] {
    let bibleText = title.readBibleTxt()
    var bible = [Self]()
    bibleText.forEach{
      let sentenceText = $0.toBible(title: title)
      bible.append(sentenceText)
    }
    return bible
  }
}


public class PersistableBible: EmbeddedObject {
  @Persisted var title: String
  @Persisted var chapter: Int
  @Persisted var section: Int
  @Persisted var chapterTitle: String?
  @Persisted var sentence: String
  
  init(bible: BibleVO) {
    self.title = bible.title
    self.chapter = bible.chapter
    self.section = bible.section
    self.chapterTitle = bible.chapterTitle
    self.sentence = bible.sentence
  }
}

extension BibleVO: CustomPersistable {
  public var persistableValue: PersistableBible { return .init(bible: self) }
  
  public init(persistedValue: PersistableBible) {
    self.init(title: persistedValue.title,
              chapter: persistedValue.chapter,
              section: persistedValue.section,
              chapterTitle: persistedValue.chapterTitle,
              sentence: persistedValue.sentence)
  }
  
  public typealias PersistedType = PersistableBible
}



public struct WrittenBibleVO: Hashable {
  public var writtenData: Data
  public var bible: BibleVO
  public var isWrite: Bool
  
  public init(writtenData: Data, bible: BibleVO, isWrite: Bool) {
    self.writtenData = writtenData
    self.bible = bible
    self.isWrite = isWrite
  }
  
  static public let defaultValue = Self(
    writtenData: Data(),
    bible: BibleVO.defaultValue,
    isWrite: false
  )
}

