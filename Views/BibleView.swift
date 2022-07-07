//
//  BibleView.swift
//  WriteBible
//
//  Created by 이택성 on 2022/06/16.
//

import SwiftUI
import RealmSwift
import Introspect

struct BibleView: View {
    @Binding var bibleTitle: BibleTitle
    @Binding var chapterNum: Int
    @ObservedObject var manager = DrawingManager()
    @State private var translation: CGSize = .zero
    @Binding var showTitle: Bool
    @ObservedRealmObject var settingValue: SettingManager
    
    @Environment(\.colorScheme) var colorScheme     // Dark모드에서 새기다 버튼 컬러를 위해 모드 감지
        
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
                self.translation = $0.translation
            })
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
        
        
        
        return ScrollViewReader { scr in
            ScrollView(.vertical) {
                VStack {
                    VStack {
                        /// Bound preference ScrollPreferenceKey tried to update multiple times per frame. 오류 발생
                        /// onPreferenceChange가 무거운듯
                        GeometryReader { proxy in       // titleView 표기
                            Color.clear.preference(key: ScrollPreferenceKey.self, value: proxy.frame(in: .named("scroll")).minY)
                        }
                        .onPreferenceChange(ScrollPreferenceKey.self, perform: { value in
                            DispatchQueue.main.async {

                                withAnimation(.easeInOut) {
                                    if value < 0 {
                                        showTitle = true
                                    }
                                    else {
                                        showTitle = false
                                    }
                                }
                            }
                        })
                        
                        // 성경 본문
                        ForEach(bible.makeBible(title: bibleTitle.rawValue).filter{$0.chapter == chapterNum}, id: \.sentence ) { name in
                            let showChpaterTitle = checkChapterTitle(chapterTitle: name.chapterTitle)
                            
                            VStack() {
                                Text(name.chapterTitle ?? "" )
                                    .font(.system(size: 22))
                                    .fontWeight(.heavy)
                                    .foregroundColor(Color.chapterTitleColor)
                                    .isHidden(showChpaterTitle)
                                
                                // 성경 구절
                                BibleSentenceView(bibleSentence: name, setting: .constant(settingValue.getSetting()))
                            }/// VStack
                            .id(name.section)
                            .padding([.bottom])
                            .listRowSeparator(.hidden)
                        }/// ForEach
                        
                        Spacer()
                   
                        
                    }///VStack
                    .id("scrollToTop")
                    .overlay() {
                        if settingValue.isEmpty() {
                            DrawingWrapper(manager: manager, title: keyTitle)
                                .id(keyTitle)
                        }
                    }
                    .onChange(of: keyTitle) { newValue in
                        withAnimation(.default) {
                            scr.scrollTo("scrollToTop", anchor: .top)
                        }
                    }
                    
                    // 새기다 버튼
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            if chapterNum < bible.getLastChapter() {
                                self.chapterNum += 1
                            } else {
                                bibleTitle.next()
                                if bibleTitle != .revelation {
                                    self.chapterNum = 1
                                }
                            }
                            
                            RealmManager().written(title: keyTitle)
                            
                            print("작성완료")
                        }) {
                            
                            Rectangle()
                                .stroke(colorScheme == .light ? Color.black.opacity(0.85) : Color.white.opacity(0.85), lineWidth: 3)
                                .foregroundColor(colorScheme == .light ? .white : .black)
                                .frame(width:150 , height:50)
                                .cornerRadius(5)
                                .overlay() {
                                    HStack {
                                        Image("Pencil")
                                            .resizable()
                                            .renderingMode(.template)
                                            .aspectRatio(contentMode: .fit)
                                            .tint(colorScheme == .light ? Color.black.opacity(0.85) : Color.white.opacity(0.85))
                                        
                                        Text("새기다")
                                            .fontWeight(.semibold)
                                            .font(.subheadline)
                                            .foregroundColor(colorScheme == .light ? Color.black.opacity(0.85) : Color.white.opacity(0.85))
                                    }
                                    
                                    .padding()
                                }
                        } ///Button
                        .padding(30)

                    }///HStack
                    ///
                } ///VStack
            } /// scrollView
            .coordinateSpace(name: "scroll")
//                .onTapGesture {}
            .gesture(dragGesture)
//            .animation(.interactiveSpring(), value: translation.width)
        }/// scrollViewReader
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
        BibleView(bibleTitle: .constant(.genesis), chapterNum: .constant(1), showTitle: .constant(false), settingValue: SettingManager())
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
