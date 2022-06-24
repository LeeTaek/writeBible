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
    @ObservedObject var manager = DrawingManager()

     
    
    var body: some View {
        writeView
//            .id(bibleTitle.rawValue)
    }

    
    //MARK: - 성경 본문 view
    var writeView: some View {
        let bible = Bible(title: bibleTitle.rawValue)
        let keyTitle = bibleTitle.rawValue + chapterNum.description
        
        return GeometryReader { geo in
            ScrollViewReader { scr in
                ScrollView(.vertical) {
                        ForEach(bible.makeBible(title: bibleTitle.rawValue).filter{$0.chapter == chapterNum}, id: \.sentence ) { name in
                            let showChpaterTitle = checkChapterTitle(chapterTitle: name.chapterTitle)

                            VStack {
                                Text(name.chapterTitle ?? "" )
                                    .font(.system(size: 22))
                                    .fontWeight(.heavy)
                                    .foregroundColor(Color.chapterTitleColor)
                                    .isHidden(showChpaterTitle)
                                    
                                    
                                
                                    HStack (alignment: .top){
                                        // 성경 구절
                                        BibleSentenceView(bibleSentence: name)
                                            .frame(width: geo.size.width/2, alignment: .leading)
                                            
                                        // 필사 뷰 절 번호
                                        Text("\(name.section)")
                                            .bold()
                                            .font(.system(size: 17))
                                            
                                        
                                        // 필사하는 부분 line
                                        VStack (alignment: .leading, spacing: 30){
                                            ForEach(1..<5, id: \.self) { _ in
                                                Rectangle()
                                                  .opacity(0.2)
                                                  .frame(width: geo.frame(in: .global).size.width/7 * 3, height: 2)
                                                  .position(x: (geo.frame(in: .global).midX + geo.frame(in: .global).minX)/2 - 20 , y: 22)
                                            }
                                        }/// VStack
                                    .padding([.bottom])
                                    .listRowSeparator(.hidden)
                                }/// HStack
                            }
                        }/// ForEach
                        .id("scrollToTop")
                        .overlay() {
                            DrawingWrapper(manager: manager, title: keyTitle)
                                .id(keyTitle)
                        }
                        .listStyle(.plain)
                        .onChange(of: keyTitle) { newValue in
                            withAnimation(.default) {
                                scr.scrollTo("scrollToTop", anchor: .top)
                            }
                        }
                    } /// scrollView
                }/// scrollViewReader
            } /// geometry
        }
    
    
    
    func checkChapterTitle(chapterTitle: String?) -> Bool {
        return chapterTitle != nil ? false : true
    }
    
 
    
}


struct BibleView_Previews: PreviewProvider {
    static var previews: some View {
        BibleView(bibleTitle: .constant(.genesis), chapterNum: .constant(1))
    }
}





extension View {
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}
