//
//  SettingView.swift
//  WriteBible
//
//  Created by 이택성 on 2022/06/27.
//

/*
    setting View
    
 */
import Store
import SwiftUI

import ComposableArchitecture

struct SettingView: View {
    let store: StoreOf<SettingStore>
    @ObservedObject var viewStore: ViewStoreOf<SettingStore>
   
    init(store: StoreOf<SettingStore>) {
        self.store = store
        self.viewStore = ViewStore(self.store, observe: { $0 })
    }
    

    var body: some View {
        VStack{
            settingTitle
            settingView
        }.interactiveDismissDisabled(true)
    }
    
    
    //MARK: - Sheet창의 성경 제목
    var settingTitle: some View {
        HStack {
            Text("설정")
                .font(.title)
                .fontWeight(.heavy)
                .foregroundColor(.titleTextColor)
                .padding()
            Spacer()
            Button("+") {
                viewStore.send(.closeSettingSheet(true))
            }
        }
        .background(Color.titleBackground)
    }
    
    
    //MARK: - setting창 내용
    var settingView: some View {
        GeometryReader { geo in
            HStack {
                // 샘플 보기
                Form {
                    Section {
                        VStack(alignment: .center) {
                            Text("주의 말씀의 맛이 내게 어찌 그리 단지요\n 내 입에 꿀보다 더 다니이다. \n ")
                            .tracking(viewStore.setting.traking)
                            .font(.custom(viewStore.setting.font.rawValue, size: viewStore.setting.fontSize))
                            .lineSpacing(viewStore.setting.lineSpace)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                            
                            Text("- 시 119:103")
                            .tracking(viewStore.setting.traking)
                            .font(.custom(viewStore.setting.font.rawValue, size: viewStore.setting.fontSize))
                            .lineSpacing(viewStore.setting.lineSpace)
                                .background(
                                    GeometryReader {            //라인 계산을 위한 base frame height
                                        Color.clear.preference(key: ViewHeightKey.self,
                                                               value: $0.frame(in: .local).size.height)
                                    })
                                .onPreferenceChange(ViewHeightKey.self) {
                                  self.viewStore.send(.updateLineHeight($0))
                                }
                            
                            Spacer()
                            
                            
                            
                        }
                        .frame(height: geo.frame(in: .local).height * 0.85)
                        .padding()
                    } header: {
                        Text("Samples")
                            .tracking(2)
                            .font(.system(size: 15))
                            .fontWeight(.bold)
                            .foregroundColor(.titleBackground)
                    }
                }
                .frame(width: geo.frame(in: .local).width * 0.46)
                
                Form {
                    // 글체 설정
                    Section {
                      Picker("글체", selection: viewStore.$setting.font) {
                                    ForEach(FontCase.allCases, id: \.self) {
                                        fontTitle(font: $0)
                                            .tag($0)
                                    }
                                }
                                .pickerStyle(.segmented)
                        
                    } header: {
                        Text("글체")
                            .tracking(2)
                            .font(.system(size: 15))
                            .fontWeight(.bold)
                            .foregroundColor(.titleBackground)
                    }
                    
                    
                    //폰트 크기 설정
                    Section {
                      Slider(value: viewStore.$setting.fontSize,
                             in: 20...35,
                             step: 1,
                             label: { Text("fontSize") },
                             minimumValueLabel: { Text("20") },
                             maximumValueLabel: { Text("35") }
                      )
                      .accentColor(.titleBackground)
                      
                    } header: {
                      Text("글자 크기: \(Int(viewStore.setting.fontSize))")
                            .tracking(2)
                            .font(.system(size: 15))
                            .fontWeight(.bold)
                            .foregroundColor(.titleBackground)
                    }
                    
                    // 글자 간격
                    Section {
                      Slider(value: viewStore.$setting.traking,
                             in: 1...5,
                             step: 1,
                             label: { Text("traking") },
                             minimumValueLabel: { Text("1") },
                             maximumValueLabel: { Text("5") }
                      )
                      .accentColor(.titleBackground)

                    } header: {
                      Text("글자 간격 : \(Int(viewStore.setting.traking))")
                            .tracking(2)
                            .font(.system(size: 15))
                            .fontWeight(.bold)
                            .foregroundColor(.titleBackground)
                    }
                    
                    
                    // 줄 간격
                    Section {
                      Slider(value: viewStore.$setting.lineSpace,
                             in: 10...25,
                             step: 1,
                             label: { Text("line spacing") },
                             minimumValueLabel: { Text("10") },
                             maximumValueLabel: { Text("25") }
                      )
                      .accentColor(.titleBackground)
                        
                    } header: {
                      Text("줄 간격 : \(Int(viewStore.setting.lineSpace))")
                            .tracking(2)
                            .font(.system(size: 15))
                            .fontWeight(.bold)
                            .foregroundColor(.titleBackground)
                            .foregroundColor(.titleBackground)
                    }
                    
                    // 완료 버튼
                  Button(action: {
                    viewStore.send(.closeSettingSheet(true))
                  }, label: {
                    Text("완료")
                        .fontWeight(.bold)
                        .foregroundColor(.titleBackground)
                        .frame(maxWidth: .infinity, alignment: .center)
                  })
                         
                } /// Form
            }/// HStack
        }///geometry
    }
    
    
    
    
    @ViewBuilder func fontTitle(font: FontCase) -> some View {
        switch font {
            case .gothic :
                Text("나눔바른고딕")
                .font(.custom("NanumBarunGothic", size: 10))
            case .myeongjo:
                Text("나눔명조")
                .font(.custom("NanumMyeongjo", size: 10))
            default:
                Text("나눔손글씨 꽃내음")
                .font(.custom("나눔손글씨 꽃내음", size: 10))
        }
    }
    
}





//
//struct SettinView_Previews: PreviewProvider {
//    static var previews: some View {
//        let setting = SettingModel(lineSpace: 11, fontSize: 20, traking: 2)
//        var showing = true
//        let settingManager = SettingManager(setting: setting)
//        
//        let store = Store(initialState: SettingStore.State(setting: setting,
//                                                         showSettingSheet: showing,
//                                                         settingManager: settingManager),
//                          reducer: SettingStore())
//      
//        SettingView(store: store)
//    }
//}
//
//#Preview {
//  let setting = SettingModel(lineSpace: 11, fontSize: 20, traking: 2)
//  var showing = true
//  let settingManager = SettingManager(setting: setting)
//  
//  let store = Store(initialState: SettingStore.State(setting: setting,
//                                                   showSettingSheet: showing,
//                                                   settingManager: settingManager),
//                    reducer: SettingStore())
//
//  return SettingView(store: store)
//}
