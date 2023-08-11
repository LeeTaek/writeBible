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
  
  @Environment(\.colorScheme) var colorScheme     // Dark모드에서 새기다 버튼 컬러를 위해 모드 감지
  
  public var body: some View {
    VStack {
      simpleTitle
      bibleSentencesList
    }
    .padding(.horizontal)
//    .overlay {
//      TitleView(
//        store: self.store.scope(state: \.title,
//                                action: BibleStore.Action.titleAction)
//      )
//    }
    .onAppear {
      viewStore.send(.onAppear)
    }
  }
  
  
  
  /// 챕터 타이틀
  var simpleTitle: some View {
    let name = viewStore.title.rawValue.rawTitle()
    
    return  Text("\(name) \(viewStore.chapter)장")
      .font(.system(size: 25))
      .fontWeight(.bold)
      .foregroundColor(.simpleTitleColor)
      .frame(height: 30)
  }
    
  
  /// 본문
  var bibleSentencesList: some View {
    let keyTitle = viewStore.title.rawValue + viewStore.chapter.description
//    let dragGesture = DragGesture()
//      .onChanged({
//        self.translation = $0.translation
//      })
//      .onEnded {
//        /// 다음장 혹은 이전장으로 넘어가기 위한 드래그 제스쳐
//        if $0.translation.width < -100 {                           //드래그 가로의 위치가 -100보다 작은 위치로 가면 실행
//          퍋ㅈ
//        } else if $0.translation.width > 100 {                  //드래그 가로의 위치가 100보다 커지면 실행
//          moveToBeforeChapter()
//        }
//        self.translation = .zero
//      }

    return ScrollViewReader{ scr in
      ScrollView(.vertical, showsIndicators: false) {
        LazyVStack(alignment: .leading){
          ForEachStore(
            self.store.scope(state: \.sentences, action: BibleStore.Action.sentence(id:action:))
          ) { sentenceStore in
            BibleSentenceView(store: sentenceStore)
              .padding([.bottom])
              .listRowSeparator(.hidden)
          }
        }
      }
      .id("scrollToTop")
      .onChange(of: keyTitle) { newValue in
        withAnimation(.default) {
          scr.scrollTo("scrollToTop", anchor: .top)
        }
      }
      .coordinateSpace(name: "scroll")
//      .gesture(dragGesture)
    }
  }
  
  
  
  ///새기다 버튼
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
}



#Preview {
  return BibleView(store: Store(
    initialState: BibleStore.State(title: .genesis, chapter: 1)) {
      BibleStore()
    })
}




