//
//  SettingManager.swift
//  WriteBible
//
//  Created by 이택성 on 2022/06/28.
//
//
import SwiftUI
import RealmSwift

class SettingManager: Object, ObjectKeyIdentifiable {
    static let shared = SettingManager()
    
    
    @Persisted(primaryKey: true) var id: Int
    @Persisted var lineSpace: Float
    @Persisted var fontSize: Float
    @Persisted var traking: Float
    @Persisted var baseLineHeight: Float
    @Persisted var font: String
    
    convenience init(setting: SettingModel) {
        self.init()
        
        self.id  = 0
        self.lineSpace = Float(setting.lineSpace)
        self.fontSize = Float(setting.fontSize)
        self.traking = Float(setting.traking)
        self.baseLineHeight = Float(setting.baseLineHeight)
        self.font = setting.font.rawValue
        
    }
    
    
    func updateSetting(setting: SettingModel) {
        let realm = try! Realm()
        let saveData = SettingManager(setting: setting)
        
        if let loaded = realm.object(ofType: SettingManager.self, forPrimaryKey: 0) {
                try! realm.write {
                    loaded.fontSize = Float(setting.fontSize)
                    loaded.traking = Float(setting.traking)
                    loaded.lineSpace = Float(setting.lineSpace)
                    loaded.baseLineHeight = Float(setting.baseLineHeight)
                    loaded.font = setting.font.rawValue
                }

        } else {
            try! realm.write {
                print(#fileID, #function, #line, "\(setting.fontSize)")
                realm.add(saveData)
            }
        }
    }
    
    
    func getSetting() -> SettingModel {
        let realm = try! Realm()
            
        if let saved = realm.object(ofType: SettingManager.self, forPrimaryKey: 0) {
            return SettingModel(lineSpace: CGFloat(saved.lineSpace), fontSize: CGFloat(saved.fontSize), traking: CGFloat(saved.traking), baseLineHeight: CGFloat(saved.baseLineHeight), font: FontCase(rawValue: font)!)
        } else {
            return SettingModel(lineSpace: 11, fontSize: 20, traking: 1)
        }
    }
    
    
    
    func isEmpty() -> Bool {
        let realm = try! Realm()
        
        if let _ = realm.object(ofType: SettingManager.self, forPrimaryKey: 0) {
            return true
        } else {
            return false
        }
    }

}
