//
//  TitleView.swift
//  WriteBible
//
//  Created by 이택성 on 2022/06/08.
//

import Store
import SwiftUI

import ComposableArchitecture
import RealmSwift


struct TitleView: View {
  let store: StoreOf<TitleStore>
  @ObservedObject var viewStore: ViewStoreOf<TitleStore>
  
  init(store: StoreOf<TitleStore>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }

  
//    @Binding var bibleTitle: BibleTitle
//    @Binding var chapter: Int
//    @Binding var showTitleSheet: Bool
//    @State private var showTitle = false
//    @State var showiSettingSheet = !SettingManager().isEmpty()  // setting 초기 설정을 위한 변수
//    @ObservedRealmObject var settingValue: SettingManager

    @Environment(\.colorScheme) var colorScheme     // Dark모드에서 새기다 버튼 컬러를 위해 모드 감지


    var body: some View {
        VStack {
            title
            Spacer()
        }
    }
    
    
    //MARK: - Title View
    var title: some View {
//        let titleName = bibleTitle.rawValue.rawTitle()
      let titleName = viewStore.bibleTitle.rawValue.rawTitle()
        
        return HStack{
            //MARK: -  Title 창
          Button(action: { self.viewStore.send(.showTitleSheet(true)) }) {
            Text("\(titleName) \(viewStore.chapter)장")
                    .font(.system(size: 30))
                    .padding()
                    .foregroundColor(.titleTextColor)
            }
            .sheet(
              isPresented: viewStore.binding(
                get: { $0.showTitleSheet },
                send: .showTitleSheet(true)
              )
            ){
                  VStack {
                      contents
                      
                      bibleList
                          .padding()
                  }
              }


            Spacer()
            
            
            //MARK: - 설정창 sheet
          Button(action: { self.viewStore.send(.showSettingSheet(true)) })  {
                Image(systemName: "gearshape")
                    .foregroundColor(Color.titleTextColor)
                    .padding()
                    
            }
//          .sheet(
//            isPresented: viewStore.binding(
//              get: { $0.showSettingSheet },
//              send: .showSettingSheet(true)
//            )) {
//              SettingView(store: Store(initialState: SettingStore.State()){
//                SettingStore()
//              })
//            }
//          .sheet(isPresented: $showiSettingSheet) {
//                // 앱 처음 실행시 셋팅값이 없다면 setting 창을 띄워준다.
////                SettingView(setting: settingValue.getSetting(), showSettingSheet: $showiSettingSheet)
//            }

            
        }
        .background(Color.titleBackground)
        .frame( height: 40 )
    }


    
    
    //MARK: - Sheet창의 성경 제목
    var contents: some View {
        HStack {
            Text("목차")
                .font(.title)
                .fontWeight(.heavy)
                .foregroundColor(.titleTextColor)
                .padding()
            
            Spacer()
           
            Button(action: { self.viewStore.send(.showTitleSheet(false)) }) {
                Image(systemName: "x.circle")
                    .foregroundColor(.titleTextColor)
                    
            }
            .padding()
        }
        .background(Color.titleBackground)

        
    }
    
    
    //MARK: - Sheet창의 장
    var bibleList: some View {
        return HStack {
          titleList
          chapterList
        }
    }
  
  var titleList: some View {
    List {
      ForEach(BibleTitle.allCases, id: \.self) { title in
            let titleName = title.rawValue.rawTitle()

            Button(action: { self.viewStore.send(.selectTitle(title)) }) {
                VStack {
                    Text("\(titleName)")
                }
            }
            .listRowBackground(viewStore.bibleTitle == title ? Color.selectedColor : Color(UIColor.systemBackground))
        }

    }
    .listStyle(.plain)
  }
    
  
  var chapterList: some View {
    List{
      ForEach((1...viewStore.lastChapter), id: \.self) { chapter in
          Button(action: { self.viewStore.send(.selectChapter(chapter)) }) {
                HStack {
                    Text("\(chapter)")
                    Spacer()
                    
                  if BibleSentenceVO.completeChapter(title: viewStore.bibleTitle.rawValue, chapter: viewStore.chapter) {
                        Image("Pencil")
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 30, height:30)
                            .tint(colorScheme == .light ? Color.black.opacity(0.85) : Color.white.opacity(0.85))
                    }
                }
            }
          .listRowBackground(viewStore.chapter == chapter ? Color.selectedColor : Color(UIColor.systemBackground))
        }
        
    }.listStyle(.plain)
  }
    
    
    
    
}

// 
//#Preview {
//  let store = Store(initialState: TitleStore.State(),
//                    reducer: TitleStore())
//
//  return TitleView(store: store)
//}


struct SettinView_Previews: PreviewProvider {
    static var previews: some View {
      let store = Store(initialState: TitleStore.State()) {
        TitleStore()
      }

      return TitleView(store: store)
    }
}
