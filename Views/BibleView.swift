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
    @State private var translation: CGSize = .zero
    
    @Binding var showTitle: Bool
    
//    @ObservedObject var scrollData: ScrollDetectorData 
    

    
    var body: some View {
        VStack {
            simpleTitle
            writeView

        }
        
    }

    
    //MARK: - 성경 본문 view
    var writeView: some View {
        let bible = Bible(title: bibleTitle.rawValue)
        let keyTitle = bibleTitle.rawValue + chapterNum.description
        let dragGesture = DragGesture()
            .onChanged({
                self.translation = $0.translation })
            .onEnded {
                  if $0.translation.width < -100 {                           //드래그 가로의 위치가 -100보다 작은 위치로 가면 실행
                      if chapterNum < bible.getLastChapter() {
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
     
        
        
        
        return GeometryReader { geo in
            ScrollViewReader { scr in
                ScrollView(.vertical) {
                    VStack {
                        GeometryReader { proxy in
                            Color.clear.preference(key: ScrollPreferenceKey.self, value: proxy.frame(in: .named("scroll")).minY)
                        }.onPreferenceChange(ScrollPreferenceKey.self, perform: { value in
                            withAnimation(.easeInOut) {
                                print(value)
                                if value < 0 {
                                    showTitle = true
                                }
                                else {
                                    showTitle = false
                                }
                            }
                        })
                
                        
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
                            }/// VStack
                        }/// ForEach
                    }
                        .id("scrollToTop")
                        .overlay() {
                            DrawingWrapper(manager: manager, title: keyTitle)
                                .id(keyTitle)
                        }
                        .onChange(of: keyTitle) { newValue in
                            withAnimation(.default) {
                                scr.scrollTo("scrollToTop", anchor: .top)
                                print(scr)
                            }
                        }
                    } /// scrollView
                .coordinateSpace(name: "scroll")
                .onTapGesture {}
                    .gesture(dragGesture)
                    .offset(x: translation.width)
                    .animation(.interactiveSpring(), value: translation.width)
                }/// scrollViewReader
            } /// geometry
        }
    
    
    
    var simpleTitle: some View {
        let ti = bibleTitle.rawValue.components(separatedBy: ".").first!
        let name = ti[4..<ti.count]
        
        return  Text("\(name) \(chapterNum)장")
            .font(.system(size: 25))
            .fontWeight(.bold)
            .foregroundColor(.simpleTitleColor)
            .frame(height: 30)
    }
    
    
    func checkChapterTitle(chapterTitle: String?) -> Bool {
        return chapterTitle != nil ? false : true
    }
    
 
    
}


struct BibleView_Previews: PreviewProvider {
    static var previews: some View {
        BibleView(bibleTitle: .constant(.genesis), chapterNum: .constant(1), showTitle: .constant(false)  )
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
