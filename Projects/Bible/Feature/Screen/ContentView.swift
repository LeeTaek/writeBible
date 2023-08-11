//
//  ContentView.swift
//  WriteBible
//
//  Created by 이택성 on 2022/06/02.
//

import Store
import SwiftUI

import ComposableArchitecture
import RealmSwift

public struct ContentView: View {
//    @ObservedResults(SettingManager.self, configuration: Realm.Configuration(schemaVersion: 1)) var settingValue        //셋팅값을 위한 RealmDB
//
//        
    public init() {
//        @ObservedResults(SettingManager.self, configuration: Realm.Configuration(schemaVersion: 1)) var settingValue        //셋팅값을 위한 RealmDB
    }
    
    
    public var body: some View {
//        let setting = settingValue.first ?? SettingManager()

      return BibleView(store: Store(initialState: BibleStore.State(title: .genesis, chapter: 1)) {
        BibleStore()
      })
//        return BibleView(settingValue: setting)
//            .overlay() {
//                TitleView(bibleTitle: $bibleTitle, chapter: $chapterNum, showTitleSheet: $showingSheet, settingValue: setting)
//                        .opacity(showTitle ? 0 : 1)
//            }.onAppear(){
//
//                let saved = RecentWritingManager().getSetting()
//                print(saved)
//                chapterNum = Int(String(saved.components(separatedBy: "txt").last!))!
//                bibleTitle = BibleTitle(rawValue: saved.components(separatedBy: "txt").first! + "txt")!
//
//            }

    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

