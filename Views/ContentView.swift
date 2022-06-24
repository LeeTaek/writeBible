//
//  ContentView.swift
//  WriteBible
//
//  Created by 이택성 on 2022/06/02.
//

import SwiftUI

struct ContentView: View {
    
    @State private var translation: CGSize = .zero

    @State var bibleTitle: BibleTitle = .genesis
    @State var chapterNum: Int = 1
    @State private var showingSheet = false

    
    var body: some View {
        let lastChapter = Bible(title: bibleTitle.rawValue).getLastChapter()
        
        let dragGesture = DragGesture()
            .onChanged({ self.translation = $0.translation })
            .onEnded {

                  if $0.translation.width < -100 {                           //드래그 가로의 위치가 -100보다 작은 위치로 가면 실행
                      if chapterNum < lastChapter {
                          self.chapterNum += 1
                      } else {
                          bibleTitle.next()
                          if bibleTitle != .revelation {
                              self.chapterNum = 1
                          }
                      }
        
                  } else if $0.translation.width > 100 {                  //드래그 가로의 위치가 100보다 커지면 실행
                      if chapterNum > 1 {
                          self.chapterNum -= 1
                      } else {
                          bibleTitle.before()
                          if bibleTitle != .genesis {
                              self.chapterNum = Bible(title: bibleTitle.rawValue).getLastChapter()
                          }
                      }
                  }
                
                self.translation = .zero
            }
     
        
        return VStack {
            TitleView(bibleTitle: $bibleTitle, chapter: $chapterNum, showTitleSheet: $showingSheet)
        
            BibleView(bibleTitle: $bibleTitle, chapterNum: $chapterNum)
                .offset(x: translation.width)
                .gesture(dragGesture)
                .animation(.interactiveSpring(), value: translation)

        }
    }
    
    

}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

