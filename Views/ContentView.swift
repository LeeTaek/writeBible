//
//  ContentView.swift
//  WriteBible
//
//  Created by 이택성 on 2022/06/02.
//

import SwiftUI

struct ContentView: View {
    
    @State var bibleTitle: BibleTitle = .genesis
    
    @State var chapterNum: Int = 1
    @State private var showingSheet = false
    @State private var showTitle = false
    
    
    @State var setting = SettingModel(lineSpace: 11, fontSize: 20, traking: 2)

//    @ObservedObject var scrollData: ScrollDetectorData = .init()

    
    var body: some View {
        
          
            
        BibleView(bibleTitle: $bibleTitle, chapterNum: $chapterNum, showTitle: $showTitle, settingValue: $setting)
        .overlay() {
            TitleView(bibleTitle: $bibleTitle, chapter: $chapterNum, showTitleSheet: $showingSheet, settingValue: $setting)
                    .opacity(showTitle ? 0 : 1)
        }
    
    }
    
    
   
    

}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

