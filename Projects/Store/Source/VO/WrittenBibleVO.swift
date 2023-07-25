//
//  WrittenBibleVO.swift
//  Store
//
//  Created by openobject on 2023/07/25.
//  Copyright © 2023 leetaek. All rights reserved.
//

import Foundation

import RealmSwift

public struct Bible: Hashable {
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
}

public struct WrittenBibleVO: Hashable {
  public var writtenData: Data
  public var bible: Bible
  public var isWrite: Bool
  
  public init(writtenData: Data, bible: Bible, isWrite: Bool) {
    self.writtenData = writtenData
    self.bible = bible
    self.isWrite = isWrite
  }
  
  static public let defaultValue = Self(
    writtenData: Data(),
    bible: Bible.defaultValue,
    isWrite: false
  )
  
  
  func fileRead() -> [String] {
    let textPath = Bundle.module.path(forResource: "\(self.bible.title)", ofType: nil)
    let encodingEUCKR = CFStringConvertEncodingToNSStringEncoding(0x0422)
    var genesis = [String]()
    
    do {
      let contents = try String(contentsOfFile: textPath!,
                                encoding: String.Encoding(rawValue: encodingEUCKR))
      Log.debug(textPath!)
      genesis = contents.components(separatedBy: "\r")
    } catch {
      Log.debug(error.localizedDescription)
    }
    return genesis
  }
  
  
  func makeBible(title: String) -> [Self] {
    let bibleText = fileRead()
    var bibleVO = [Self]()
    
    bibleText.forEach{
      let sentenceText = $0.toBible(title: title)
      let vo = WrittenBibleVO(writtenData: Data(),
                              bible: sentenceText,
                              isWrite: true)
      bibleVO.append(vo)
    }
    return bibleVO
  }
  
}


extension Bible: CustomPersistable {
  public typealias PersistedType = String
  public init(persistedValue: String) { self.init(persistedValue: persistedValue) }
  public var persistableValue: String { String(sentence) }
}
