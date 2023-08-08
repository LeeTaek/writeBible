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

struct BibleSentenceView: View {
  let store: StoreOf<SentenceStore>
  @ObservedObject var viewStore: ViewStoreOf<SentenceStore>

  init(store: StoreOf<SentenceStore>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
//    ///사용하는 메인뷰의 높이를 구하기위해 사용하는 변수
//    @State var textHeight : CGFloat = .zero
//    @State var line: Int = 3
//    @Binding var setting: SettingModel

    var body: some View {
      VStack {
        Text(viewStore.sentence.chapterTitle ?? "")
          .font(.system(size: 22))
          .fontWeight(.heavy)
          .foregroundColor(Color.chapterTitleColor)
          .isHidden(viewStore.sentence.chapterTitle != nil)

        HStack(alignment: .top) {
          sentenceDescription
          writtingLineView
        }
        .frame(height: self.viewStore.textHeight)
      }
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
    .onPreferenceChange(ViewHeightKey.self) {
      // Frame 높이에 따라 그릴 Line 수 계산
      self.viewStore.send(.getLine($0))
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

//
//struct BibleSentenceView_Previews: PreviewProvider {
//    static var previews: some View {
//        let bible = Bible(title: "요한계시록", chapter: 4, section: 1, sentence: "이 일 후에 내가 보니 하늘에 열린 문이 있는데 내가 들은 바 처음에 내게 말하던 나팔 소리 같은 그 음성이 이르되 이리로 올라오라 이 후에 마땅히 일어날 일들을 내가 네게 보이리라 하시더라")
//        
//        BibleSentenceView(bibleSentence: bible, setting: .constant(SettingModel(lineSpace: 11, fontSize: 20, traking: 2)))
//    }
//}
