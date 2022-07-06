//
//  ContentView.swift
//  WriteBible
//
//  Created by 이택성 on 2022/06/02.
//

import SwiftUI
import RealmSwift

struct ContentView: View {
    
    @State var bibleTitle: BibleTitle = .genesis
    @State var chapterNum: Int = 1
    @State private var showingSheet = false
    @State private var showTitle = false
    @ObservedResults(SettingManager.self) var settingValue
//    @ObservedResults(RecentWrittingManager.self) var recentValue

    @State var isLoading: Bool = true
        
    
    var body: some View {
        let setting = settingValue.first ?? SettingManager()
//        let recentData = recentValue.first ?? RecentWrittingManager()
      

        return BibleView(bibleTitle: $bibleTitle, chapterNum: $chapterNum, showTitle: $showTitle, settingValue: setting)
            .overlay() {
                TitleView(bibleTitle: $bibleTitle, chapter: $chapterNum, showTitleSheet: $showingSheet, settingValue: setting)
                        .opacity(showTitle ? 0 : 1)
            }.onAppear(){
                
                let saved = RecentWrittingManager().getSetting()
                print(saved)
                chapterNum = Int(String(saved.components(separatedBy: "txt").last!))!
                bibleTitle = BibleTitle(rawValue: saved.components(separatedBy: "txt").first! + "txt")!
                
            }

    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

