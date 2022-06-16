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
    @State var showingWriteView = false

    
    var body: some View {
        return VStack {
            title
        
            BibleView(bibleTitle: $bibleTitle, chapterNum: $chapterNum)
        }
    }
    

    
    
    //MARK: - Title View
    var title: some View {
        let ti = bibleTitle.rawValue.components(separatedBy: ".").first!
        let name = ti[4..<ti.count]
        
        return HStack{
            
            Button("\(name) \(chapterNum)장") {
                        self.showingSheet.toggle()
                    }
                    .font(.system(size: 30))
                    .padding()
                    .sheet(isPresented: $showingSheet) {
                        TitleView(title: $bibleTitle, chapter: $chapterNum)
                    }
            
            Spacer()
            
            Button {
                self.showingWriteView.toggle()
            } label: {
                Image(systemName: "pencil")
                    .font(.system(size: 20))
                    .padding()
            }
        }
    }
    
   
    
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

