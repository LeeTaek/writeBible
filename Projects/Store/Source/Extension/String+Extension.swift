//
//  String+Extension.swift
//  Store
//
//  Created by openobject on 2023/07/25.
//  Copyright © 2023 leetaek. All rights reserved.
//

import Foundation

extension String {
  subscript(_ index: Int) -> Character {
    return self[self.index(self.startIndex, offsetBy: index)]
  }
  
  subscript(_ range: Range<Int>) -> String {
    let fromIndex = self.index(self.startIndex, offsetBy: range.startIndex)
    let toIndex = self.index(self.startIndex,offsetBy: range.endIndex)
    return String(self[fromIndex..<toIndex])
  }
  
  func readBibleTxt() -> [String] {
    guard let textPath = Bundle.module.path(forResource: "\(self)", ofType: nil) else {
      Log.error("파일 경로를 찾을수 없음: \(self)")
      return []
    }
    let encodingEUCKR = CFStringConvertEncodingToNSStringEncoding(0x0422)
    var genesis = [String]()
    
    
    do {
      let contents = try String(contentsOfFile: textPath,
                                encoding: String.Encoding(rawValue: encodingEUCKR))
      Log.debug(textPath)
      genesis = contents.components(separatedBy: "\r")
    } catch {
      Log.debug(error.localizedDescription)
    }
    return genesis
  }
  
  
  func toBible(title: String) -> BibleSentenceVO {
    var prefix = ""
    var surfix = ""
    var subTitle: String?
    
    for i in 0..<self.count {
      if self[i] == " " {
        prefix = self[0..<i]
        surfix = self[i+1..<self.count]
        break
      }
    }
    
    guard let chapter = Int(prefix.components(separatedBy: ":").first!),
          let section = Int(prefix.components(separatedBy: ":").last!) else { return BibleSentenceVO.defaultValue }
    
    if surfix.contains("<") {
      var foreIndex = 0
      var afterIndex = 0
      
      for i in 0..<surfix.count {
        if surfix[i] == "<" {
          foreIndex = i + 1
        } else if surfix[i] == ">" {
          afterIndex = i
          break
        }
      }
      
      subTitle = surfix[foreIndex ..< afterIndex]
      surfix = surfix[0..<foreIndex-1] + surfix[afterIndex+1..<surfix.count]
    }
    
    return BibleSentenceVO(title: title,
                 chapter: chapter,
                 section: section,
                 chapterTitle: subTitle,
                 sentence: surfix
    )
  }
  
}
