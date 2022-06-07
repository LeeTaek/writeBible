
// BibleModel

import Foundation

struct Bible {
    let title: String
    let chapterTitle: String?
    let chapter: Int
    let section: Int
    let sentence: String

    init(title: String, chapterTitle: String?, chapter: Int, section: Int, sentence: String) {            // Preview 보기 위한 Recruit 예
        self.title = title
        self.chapterTitle = chapterTitle
        self.chapter = chapter
        self.section = section
        self.sentence = sentence
    }
}



