//
//  BibleView.swift
//  WriteBible
//
//  Created by 이택성 on 2022/06/07.
//

/*
    성경 말씀을 띄워주는 View
 */

import Store
import SwiftUI

import ComposableArchitecture

public struct BibleSentenceView: View {
  let store: StoreOf<SentenceStore>
  @ObservedObject var viewStore: ViewStoreOf<SentenceStore>

  public init(store: StoreOf<SentenceStore>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }

  public var body: some View {
      VStack {
        chapterTitle

        HStack(alignment: .top) {
          sentenceDescription
          writtingLineView
        }
        .frame(height: self.viewStore.textHeight)
      }
      .onPreferenceChange(ViewHeightKey.self) {
        // Frame 높이에 따라 그릴 Line 수 계산
        self.viewStore.send(.getLine($0))
      }
    }

  
  var chapterTitle: some View {
    Text(viewStore.sentence.chapterTitle ?? "")
      .font(.system(size: 22))
      .fontWeight(.heavy)
      .foregroundColor(Color.chapterTitleColor)
      .isHidden(viewStore.sentence.chapterTitle != nil)
  }
  
  var sectionNumber: some View {
    let capterString = viewStore.sentence.section > 9 ? viewStore.sentence.section.description : viewStore.sentence.section.description + " "
    
    return Text("\(capterString)")
      .bold()
      .font(.custom(viewStore.setting.font.rawValue,
                    size: viewStore.setting.fontSize + 1))
  }
  
  
  var sentenceDescription: some View {
    HStack {
      sectionNumber
      
      Text(viewStore.sentence.sentence)
        .tracking(viewStore.setting.traking)
        .font(.custom(viewStore.setting.font.rawValue, size: viewStore.setting.fontSize))
        .lineLimit(nil)
        .lineSpacing(viewStore.setting.lineSpace)
        .fixedSize(horizontal: false, vertical: true)
//        .frame(width: geo.frame(in: .local).size.width/9 * 8, alignment: .leading)
        .background(
          GeometryReader {
            Color.clear.preference(key: ViewHeightKey.self,
                                   value: $0.frame(in: .local).size.height)
          })
    }
    .frame(width: UIScreen.main.bounds.width / 2)
    
  }
      
  
  var writtingLineView: some View {
    return HStack {
      sectionNumber

      GeometryReader { lineGeo in
        VStack (alignment: .leading, spacing: 30){
          /// 필사하는 부분 밑줄
          /// Line count = (해당 구절 전체 높이 + Line 간격) / ( 1줄의 높이 + Line 간격)
          
          ForEach(1..<self.viewStore.line, id: \.self) { _ in
            Rectangle()
              .opacity(0.2)
              .frame(width: lineGeo.frame(in: .local).size.width/9 * 8, height: 2)
//              .position(x: (geo.frame(in: .local).midX + geo.frame(in: .local).minX)/2 - 20 ,
//                        y: geo.frame(in: .local).minY + viewStore.setting.fontSize + (viewStore.setting.lineSpace*0.5))
          
          }
        }
      }
      .frame(width: UIScreen.main.bounds.width / 2)
    }
    .padding([.trailing,.leading])
  }
  
}



/// View Height을 구하기 위한 Preference Key
/// https://stackoverflow.com/questions/66485411/dynamic-texteditor-overlapping-with-other-view
struct ViewHeightKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}



#Preview {
  let sentence = BibleSentenceVO.defaultValue
  
  return BibleSentenceView(store: Store(
    initialState: SentenceStore.State(id: UUID(), sentence: sentence)) {
      SentenceStore()
    })
}
