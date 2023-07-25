//
//  SettingManager.swift
//  WriteBible
//
//  Created by 이택성 on 2022/06/28.
//
//

/*
    폰트, 글자크기, 글자 간격, 줄 간격 등의 셋팅값을 저장하기 위한 DB
 */

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
    
    //MARK: - setting 값 생성 및 업데이트
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
//              Log.debug(#fileID, #function, #line, "\(setting.fontSize)")
                realm.add(saveData)
            }
        }
    }
    
    
    //MARK: - 셋팅값 Read
    func getSetting() -> SettingModel {
        let realm = try! Realm()
                
        if let saved = realm.object(ofType: SettingManager.self, forPrimaryKey: 0) {
            var fontcase: FontCase
            
            if saved.font == "나눔바른고딕" || saved.font == "NanumBarunGothic" {
                fontcase = .gothic
            } else if saved.font == "나눔명조" || saved.font == "NanumMyeongjo" {
                fontcase = .myeongjo
            } else {
                fontcase = .flower
            }

            return SettingModel(lineSpace: CGFloat(saved.lineSpace), fontSize: CGFloat(saved.fontSize), traking: CGFloat(saved.traking), baseLineHeight: CGFloat(saved.baseLineHeight), font: fontcase)
        } else {
            return SettingModel(lineSpace: 11, fontSize: 20, traking: 1, font: .gothic)
        }
    }
    
    
    //MARK: -  setting값 isEmpty
    func isEmpty() -> Bool {
        let realm = try! Realm()
        
        if let _ = realm.object(ofType: SettingManager.self, forPrimaryKey: 0) {
            return true
        } else {
            return false
        }
    }

}
