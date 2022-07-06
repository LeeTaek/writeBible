//
//  RecentWrittingManager.swift
//  WriteBible
//
//  Created by 이택성 on 2022/07/06.
//
import SwiftUI
import RealmSwift

class RecentWrittingManager: Object, ObjectKeyIdentifiable {
    static let shared = RecentWrittingManager()
    
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
        let saveData = RecentWrittingManager(bibleTitle: bibleTitle, chapter: chapter)
        
        if let loaded = realm.object(ofType: RecentWrittingManager.self, forPrimaryKey: 0) {
                try! realm.write {
                    loaded.bible = bibleTitle
                    loaded.chapter = chapter
                }

        } else {
            try! realm.write {
                print(#fileID, #function, #line, "")
                realm.add(saveData)
            }
        }
    }
    
    
    func getSetting() -> String {
        let realm = try! Realm()
            
        if let saved = realm.object(ofType: RecentWrittingManager.self, forPrimaryKey: 0) {
            return saved.bible + saved.chapter.description
        } else {
            return "1-01창세기.txt1"
        }
    }
}
