//
//  TitleView.swift
//  WriteBible
//
//  Created by 이택성 on 2022/06/08.
//

import SwiftUI

struct TitleView: View {
    @Binding var title: BibleTitle
    @Binding var chapter: Int
    
    var body: some View {
        let lastChapter = Bible(title: title.rawValue, chapterTitle: nil).lastChapter()
        
        HStack {
        
            Picker("성경본문", selection: $title) {
                ForEach(BibleTitle.allCases, id: \.self) {
                    Text($0.rawValue)
                        .tag($0)
                }
            }
            .padding()
            
            
            Picker("절", selection: $chapter){
                ForEach((1...lastChapter), id: \.self) {
                    Text("\($0)")
                        .tag($0)
                }.listStyle(.insetGrouped)
            }
            
            
            
        }
        
            

    
    }
    
    
    
    
}

//struct TitleView_Previews: PreviewProvider {
//   
//    static var previews: some View {
//        TitleView(title: "$bibleTitle", chapter: Binding(0..<3))
//    }
//}
