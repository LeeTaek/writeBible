//
//  BibleView.swift
//  WriteBible
//
//  Created by 이택성 on 2022/06/16.
//

/*
    성경 View와 Drawing을 View를 그려주는 View
 */

import Store
import SwiftUI

import ComposableArchitecture
import RealmSwift

public struct BibleView: View {
  let store: StoreOf<BibleStore>
  @ObservedObject var viewStore: ViewStoreOf<BibleStore>
  
  public init(store: StoreOf<BibleStore>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
//    @State var bibleTitle: BibleTitle = .genesis
//    @State var chapterNum: Int = 1
//    @ObservedObject var manager = DrawingManager()          // Drawing View에 그린 내용을 저장하기 위한 프로퍼티
//    @State private var translation: CGSize = .zero          // 드래그 제스쳐를 위한 변수
//    @State var showTitle: Bool = false                          // title View를 보일지 말지
//    @ObservedRealmObject var settingValue: SettingManager   // RealmDB에 저장된 셋팅값을 가져옴
    
    @Environment(\.colorScheme) var colorScheme     // Dark모드에서 새기다 버튼 컬러를 위해 모드 감지
        
  public var body: some View {
        VStack {
            simpleTitle
            writeView
        }
        .overlay {
          TitleView(
            store: self.store.scope(state: \.title,
                                    action: BibleStore.Action.titleAction)
          )
        }
        .onAppear {
          viewStore.send(.onAppear)
        }
    }

    
    var writeView: some View {
      let keyTitle = viewStore.title.bibleTitle.rawValue + viewStore.title.chapter.description
//        let dragGesture = DragGesture()
//            .onChanged({
//                self.translation = $0.translation
//            })
//            .onEnded {
//                /// 다음장 혹은 이전장으로 넘어가기 위한 드래그 제스쳐
//                if $0.translation.width < -100 {                           //드래그 가로의 위치가 -100보다 작은 위치로 가면 실행
//                  moveToNextChapter()
//                } else if $0.translation.width > 100 {                  //드래그 가로의 위치가 100보다 커지면 실행
//                  moveToBeforeChapter()
//                }
//                self.translation = .zero
//            }
        
        return ScrollViewReader { scr in
//            ScrollView(.vertical) {
                VStack {
                    VStack {
                      detectScrollingView
                      bibleSentencesList
                        Spacer()
                    }
                    .id("scrollToTop")
                    .overlay() {
//                        /// 앱 처음 실행시 셋팅값 설정 후 Drawing 가능하도록 설정
//                        if settingValue.isEmpty() {
//                            DrawingWrapper(manager: manager, title: keyTitle)
//                                .id(keyTitle)
//                        }
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
                            moveToNextChapter()
//                            RealmManager().written(title: keyTitle)
                        }) {
                            buttonUI
                        }
                        .padding(30)
                    }
                }
//            }
            .coordinateSpace(name: "scroll")
//            .gesture(dragGesture)
        }
    }
    
    
    //MARK: - simple title
    var simpleTitle: some View {
      let name = viewStore.title.bibleTitle.rawValue.rawTitle()
        
        return  Text("\(name) \(viewStore.title.chapter)장")
            .font(.system(size: 25))
            .fontWeight(.bold)
            .foregroundColor(.simpleTitleColor)
            .frame(height: 30)
    }
    
    
    var detectScrollingView: some View {
      /// 수정해야 할 사항 1.
      /// Bound preference ScrollPreferenceKey tried to update multiple times per frame. 오류 발생
      /// onPreferenceChange가 무거운듯
        GeometryReader { proxy in       // titleView 표기
            Color.clear.preference(key: ScrollPreferenceKey.self, value: proxy.frame(in: .named("scroll")).minY)
        }
      .onPreferenceChange(ScrollPreferenceKey.self, perform: { value in
            DispatchQueue.main.async {

                withAnimation(.easeInOut) {
                    if value < 0 {
                      viewStore.send(.showTitle(true))
                    }
                    else {
                      viewStore.send(.showTitle(false))
                    }
                }
            }
      })
    }
  
  var bibleSentencesList: some View {
    // 본문
    List {
      ForEachStore(
        self.store.scope(state: \.sentences, action: BibleStore.Action.sentence(id:action:))
      ) { sentenceStore in
        Log.debug(sentenceStore)
        return BibleSentenceView(store: sentenceStore)
          .padding([.bottom])
          .listRowSeparator(.hidden)
      }
    }
  }

    
 
    //새기다 버튼
    var buttonUI: some View {
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
    }
  
  //MARK: - Methods
  /// 다음장으로 이동.
    func moveToNextChapter() {
      let lastChapter = viewStore.state.title.lastChapter
      
      if viewStore.title.chapter < lastChapter {
        self.viewStore.send(.titleAction(.moveTo(title: viewStore.state.title.bibleTitle,
                                                 chapter: viewStore.state.title.chapter + 1)))
      } else {
          if viewStore.title.bibleTitle != .revelation {
            self.viewStore.send(.titleAction(.moveTo(title: viewStore.state.title.bibleTitle.next(),
                                                     chapter: 1)))
          }
      }
    }
    
  
  /// 이전 장으로 이동
    func moveToBeforeChapter() {
      if viewStore.state.title.chapter > 1 {
        self.viewStore.send(.titleAction(.moveTo(title: viewStore.state.title.bibleTitle,
                                                 chapter: viewStore.state.title.chapter - 1)))
      } else {
          if viewStore.title.bibleTitle != .genesis {
            let beforeBible = viewStore.state.title.bibleTitle.before()
            let lastChapter = BibleSentenceVO.lastChapter(title: beforeBible.rawValue)
            self.viewStore.send(.titleAction(.moveTo(title: beforeBible, chapter: lastChapter)))
          }
      }
    }
    
}


//struct BibleView_Previews: PreviewProvider {
//    static var previews: some View {
//        BibleView(bibleTitle: .constant(.genesis), chapterNum: .constant(1), showTitle: .constant(false), settingValue: SettingManager())
//    }
//}





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



struct ScrollPreferenceKey: PreferenceKey {
    
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = nextValue()
    }
}
