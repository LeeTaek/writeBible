//
//  RecentWritingManager.swift
//  WriteBible
//
//  Created by 이택성 on 2022/07/06.
//

/*
    앱 실행시 마지막으로 작성하던 페이지를 열어주기 위한 DB
    마지막으로 쓰던 페이지 정보를 저장한다. 
 */

import SwiftUI
import RealmSwift

class RecentWritingManager: Object, ObjectKeyIdentifiable {
    static let shared = RecentWritingManager()
    
    @Persisted(primaryKey: true) var id: Int
    @Persisted var bible: String
    @Persisted var chapter: Int

    convenience init(bibleTitle: String, chapter: Int) {
        self.init()
        
        self.id  = 0
        self.bible = bibleTitle
        self.chapter = chapter
    }
    
    
    func updateSetting(bibleTitle: String, chapter: Int) {
        let realm = try! Realm()
        let saveData = RecentWritingManager(bibleTitle: bibleTitle, chapter: chapter)
        
        if let loaded = realm.object(ofType: RecentWritingManager.self, forPrimaryKey: 0) {
                try! realm.write {
                    loaded.bible = bibleTitle
                    loaded.chapter = chapter
                }

        } else {
            try! realm.write {
//              Log.debug(#fileID, #function, #line, "")
                realm.add(saveData)
            }
        }
    }
    
    
    func getSetting() -> String {
        let realm = try! Realm()
            
        if let saved = realm.object(ofType: RecentWritingManager.self, forPrimaryKey: 0) {
            return saved.bible + saved.chapter.description
        } else {
            return "1-01창세기.txt1"
        }
    }
}
