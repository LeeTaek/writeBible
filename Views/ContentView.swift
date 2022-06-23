//
//  ContentView.swift
//  WriteBible
//
//  Created by 이택성 on 2022/06/02.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var manager = DrawingManager()

    
    @State var bibleTitle: BibleTitle = .genesis
    @State var chapterNum: Int = 1
    @State private var showingSheet = false

    
    var body: some View {
        return VStack {
            TitleView(manager: manager, bibleTitle: $bibleTitle, chapter: $chapterNum, showTitleSheet: $showingSheet)
        
            BibleView(bibleTitle: $bibleTitle, chapterNum: $chapterNum)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

