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
        
    
    var body: some View {
        VStack {
            
            title
//            TitleView(title: $bibleTitle, chapter: $chapterNum)
    
            HStack {
                GeometryReader {
                    sen
                    .frame(width: $0.size.width / 2)
         
                }
            }
        }//Vstack
    }
    

    
    
    //MARK: - Title View
    var title: some View {
        let ti = bibleTitle.rawValue.components(separatedBy: ".").first!
        let name = ti[4..<ti.count]
        
        return HStack{
            
            Button("\(name) \(chapterNum)장") {
                        self.showingSheet.toggle()
                    }
                    .foregroundColor(.black)
                    .font(.system(size: 30))
                    .padding()
                    .sheet(isPresented: $showingSheet) {
                        TitleView(title: $bibleTitle, chapter: $chapterNum)
                    }
            
            Spacer()
            
            Image(systemName: "pencil")
                .padding()
        }
    }
    
   
    
    
    //MARK: - 성경 본문 view
    var sen: some View {
        let bible = Bible(title: bibleTitle.rawValue, chapterTitle: nil)
        
        return List(bible.makeBible(title: bibleTitle.rawValue).filter{$0.chapter == chapterNum}, id: \.sentence ) {
               BibleView(bibleSentence: $0)
                .listRowSeparator(.hidden)
        }.listStyle(.plain)
            .padding()
    }
 
  
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}




