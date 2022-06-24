//
//  RealmManager.swift
//  WriteBible
//
//  Created by 이택성 on 2022/06/22.
//

import Foundation
import SwiftUI
import RealmSwift

class RealmManager: Object, ObjectKeyIdentifiable {
    static let shared = RealmManager()
    
    @Persisted var data: Data
    @Persisted(primaryKey: true) var title: String
    
    
    convenience init(document: DrawingDocument) {
        self.init()
        
        self.data = document.data
        self.title = document.title
    }
    
    
    func addData(document: DrawingDocument) {
        let realm = try! Realm()
        let saveData = RealmManager(document: document)
        
        if isEmpty(data: document) {
            try! realm.write {
                print(#fileID, #function, #line, "\(document.title)")
                realm.add(saveData)
            }
        }
    }
    
    
    
    func getAllData() -> [DrawingDocument] {
        let realm = try! Realm()
        let DrawingRealmObjects = realm.objects(RealmManager.self)
        var DrawingDatas = [DrawingDocument]()
        
        DrawingRealmObjects.forEach { object in
            DrawingDatas.append(DrawingDocument(data: object.data, title: object.title))
        }
        
        
        return DrawingDatas
    }
    
    
    
    
    func isEmpty(data: DrawingDocument) -> Bool {
        let realm = try! Realm()
        if realm.object(ofType: RealmManager.self, forPrimaryKey: data.title) == nil {
            return true
        }
        
        return false
    }
    
    
    
    func updateData(data: DrawingDocument) {
        let realm = try! Realm()
        if let updateData = realm.object(ofType: RealmManager.self, forPrimaryKey: data.title) {
            
            try! realm.write {
                updateData.data = data.data
                
            }
        } else {
            addData(document: data)
        }
    }
    
    
    func deleteData(data: DrawingDocument) {
        let realm = try! Realm()
        if let removeData = realm.object(ofType: RealmManager.self, forPrimaryKey: data.title) {
            
            try! realm.write {
                realm.delete(removeData)
                
            }
        }
    }
}
