//
//  BibleViewModel.swift
//  WriteBible
//
//  Created by 이택성 on 2022/06/07.
//

import Foundation
import RealmSwift

class BibleViewModel: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var title: String
    @Persisted var chapter: Int
    @Persisted var section: Int
    @Persisted var sentence: String
    
    init(bible: Bible) {
        self.title = bible.title
        self.chapter = bible.chapter
        self.section = bible.section
        self.sentence = bible.sentence
    }
    
    
    //MARK: - 추가
    func addSentence(bible: Bible){
        print("경로 : \(Realm.Configuration.defaultConfiguration.fileURL!)")

        let realm = try! Realm()
        let bibleSentence = BibleViewModel(bible: bible)
        
        try! realm.write{
            realm.add(bibleSentence)
        }
    }
    
    
    
}
