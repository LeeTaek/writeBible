//
//  WrittenBibleVO.swift
//  Store
//
//  Created by openobject on 2023/07/25.
//  Copyright © 2023 leetaek. All rights reserved.
//

import Foundation

import RealmSwift

public struct BibleSentenceVO: Hashable {
  public var title: String
  public var chapter: Int
  public var section: Int
  public var chapterTitle: String?
  public var sentence: String
  public var isWritten: Bool = false
  
  static public let defaultValue = Self(
    title: "요한계시록",
    chapter: 4,
    section: 1,
    sentence: "이 일 후에 내가 보니 하늘에 열린 문이 있는데 내가 들은 바 처음에 내게 말하던 나팔 소리 같은 그 음성이 이르되 이리로 올라오라 이 후에 마땅히 일어날 일들을 내가 네게 보이리라 하시더라"
  )
}


extension BibleSentenceVO {
  /// 각 성경책 내용
  /// - Parameter title: 이름
  /// - Returns: 해당 성경책
  static func fetchBibles(title: String) -> [Self] {
    let bibleText = title.readBibleTxt()
    var bible = [Self]()
    bibleText.forEach{
      let sentenceText = $0.toBible(title: title)
      bible.append(sentenceText)
    }
    return bible
  }
  
  
  /// 해당 성경책의 개별 장
  /// - Parameters:
  ///   - title: 이름
  ///   - chapter: 필요한 장
  /// - Returns: 해당 성경책의 해당 장
  static func fetchChapter(title: String, chapter: Int) -> [Self] {
    return fetchBibles(title: title).filter{ $0.chapter == chapter }
  }
  
  
  /// 해당 성경책의 마지막 장 값
  /// - Returns: 마지막 장
  public static func lastChapter(title: String) -> Int {
    return title.readBibleTxt().count
  }
  
  
  /// 해당 장을 모두 작성했는지 여부
  /// - Parameters:
  ///   - title: 이름
  ///   - chapter: 장
  /// - Returns: 작성 안한 절이 있는지 여부 (모두 작성했으면 true / 아니면 false)
  public static func completeChapter(title: String, chapter: Int) -> Bool {
    return !self.fetchChapter(title: title, chapter: chapter).map { $0.isWritten }.contains(false)
  }
}


extension BibleSentenceVO: CustomPersistable {
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


public class PersistableBible: EmbeddedObject {
  @Persisted var title: String
  @Persisted var chapter: Int
  @Persisted var section: Int
  @Persisted var chapterTitle: String?
  @Persisted var sentence: String
  
  convenience init(bible: BibleSentenceVO) {
    self.init()
    self.title = bible.title
    self.chapter = bible.chapter
    self.section = bible.section
    self.chapterTitle = bible.chapterTitle
    self.sentence = bible.sentence
  }
}




public struct WrittenSentenceVO: Hashable {
  public var writtenData = RealmSwift.List<Line>()
  public var bible: BibleSentenceVO
  
  public init(writtenData: RealmSwift.List<Line>, bible: BibleSentenceVO) {
    self.writtenData = writtenData
    self.bible = bible
  }
  
  static public let defaultValue = Self(
    writtenData: RealmSwift.List<Line>(),
    bible: BibleSentenceVO.defaultValue
  )
  
  public func hash(into hasher: inout Hasher) {
    let id = bible.title + bible.chapter.description + bible.section.description
    return hasher.combine(id)
  }
}



public enum BibleTitle: String, Equatable, CaseIterable {  
    case genesis = "1-01창세기.txt"
    case exodus = "1-02출애굽기.txt"
    case leviticus = "1-03레위기.txt"
    case numbers = "1-04민수기.txt"
    case deuteronomy = "1-05신명기.txt"
    case joshua = "1-06여호수아.txt"
    case judges = "1-07사사기.txt"
    case ruth = "1-08룻기.txt"
    case samuel1 = "1-09사무엘상.txt"
    case samuel2 = "1-10사무엘하.txt"
    case kings1 = "1-11열왕기상.txt"
    case kings2 = "1-12열왕기하.txt"
    case chronicles1 = "1-13역대상.txt"
    case chronicles2 = "1-14역대하.txt"
    case ezra = "1-15에스라.txt"
    case nehemiah = "1-16느헤미야.txt"
    case esther = "1-17에스더.txt"
    case job = "1-18욥기.txt"
    case psalms = "1-19시편.txt"
    case proverbs = "1-20잠언.txt"
    case ecclesiasters = "1-21전도서.txt"
    case songOfSongs = "1-22아가.txt"
    case isaiah = "1-23이사야.txt"
    case jeremiah = "1-24예레미야.txt"
    case lementations = "1-25예레미야애가.txt"
    case ezekiel = "1-26에스겔.txt"
    case daniel = "1-27다니엘.txt"
    case hosea = "1-28호세아.txt"
    case joel = "1-29요엘.txt"
    case amos = "1-30아모스.txt"
    case obadiah = "1-31오바댜.txt"
    case jonah = "1-32요나.txt"
    case micah = "1-33미가.txt"
    case nahum = "1-34나훔.txt"
    case habakuk = "1-35하박국.txt"
    case zephaniah = "1-36스바냐.txt"
    case haggai = "1-37학개.txt"
    case zechariah = "1-38스가랴.txt"
    case malachi = "1-39말라기.txt"
    
    case matthew = "2-01마태복음.txt"
    case mark = "2-02마가복음.txt"
    case luke = "2-03누가복음.txt"
    case john = "2-04요한복음.txt"
    case acts = "2-05사도행전.txt"
    case romans = "2-06로마서.txt"
    case corinthians1 = "2-07고린도전서.txt"
    case corinthians2 = "2-08고린도후서.txt"
    case galatians = "2-09갈라디아서.txt"
    case ephesians = "2-10에베소서.txt"
    case philippians = "2-11빌립보서.txt"
    case colossians = "2-12골로새서.txt"
    case thessalonians1 = "2-13데살로니가전서.txt"
    case thessalonians2 = "2-14데살로니가후서.txt"
    case timothy1 = "2-15디모데전서.txt"
    case timothy2 = "2-16디모데후서.txt"
    case titus = "2-17디도서.txt"
    case philemon = "2-18빌레몬서.txt"
    case hebrews = "2-19히브리서.txt"
    case james = "2-20야고보서.txt"
    case peter1 = "2-21베드로전서.txt"
    case peter2 = "2-22베드로후서.txt"
    case john1 = "2-23요한일서.txt"
    case john2 = "2-24요한이서.txt"
    case john3 = "2-25요한삼서.txt"
    case jude = "2-26유다서.txt"
    case revelation = "2-27요한계시록.txt"
    
    public func next() -> Self {
        let allCases = type(of: self).allCases
        let currentIndex = allCases.firstIndex(of: self)!
        
        if self != .revelation {
            return allCases[currentIndex + 1]
        } else {
          return self
        }
    }
     
    public func before() -> Self {
        let allCases = type(of: self).allCases
        let currentIndex = allCases.firstIndex(of: self)!

        if self != .genesis  {
            return allCases[currentIndex - 1]
        } else  {
          return self
        }
    }
    
}

