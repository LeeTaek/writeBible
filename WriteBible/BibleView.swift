//
//  BibleView.swift
//  WriteBible
//
//  Created by 이택성 on 2022/06/16.
//

import SwiftUI

struct BibleView: View {
    @Binding var bibleTitle: BibleTitle
    @Binding var chapterNum: Int 
    
    var body: some View {
        writeView
    }
    
    //MARK: - 성경 본문 view
    var writeView: some View {
        let bible = Bible(title: bibleTitle.rawValue, chapterTitle: nil)

        return GeometryReader { geo in
            ScrollView(.vertical) {
                    ForEach(bible.makeBible(title: bibleTitle.rawValue).filter{$0.chapter == chapterNum}, id: \.sentence ) { name in
                        HStack (alignment: .top){
                            // 성경 구절
                            BibleSentenceView(bibleSentence: name)
                                .frame(width: geo.size.width/2, alignment: .leading)

                                
                            // 필사 뷰 절
                            Text("\(name.section)")
                                .bold()
                                .font(.system(size: 17))

                            
                            // 필사하는 부분 line
                            LazyVStack (alignment: .leading, spacing: 30){
                                ForEach(1..<5, id: \.self) { _ in
                                    Rectangle()
                                      .opacity(0.2)
                                      .frame(width: geo.size.width/5 * 2, height: 2)
                                      .position(x: 180,y: 22)
                                }
                            }/// LazyVStack
                            
                        }
                        .padding([.bottom])
                        .listRowSeparator(.hidden)
                    } /// list
                    .listStyle(.plain)
            } /// scrollView
      
        } /// geometry
    }
    
    
}

struct BibleView_Previews: PreviewProvider {
    
    static var previews: some View {
        BibleView(bibleTitle: .constant(.genesis), chapterNum: .constant(1))
    }
}
