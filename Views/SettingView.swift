//
//  SettingView.swift
//  WriteBible
//
//  Created by 이택성 on 2022/06/27.
//

import SwiftUI

struct SettingView: View {
    @State var setting: SettingModel
    @Binding var showSettingSheet: Bool
    var settingManager = SettingManager()
   
    

    
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
            
            Button(action: {
                settingManager.updateSetting(setting: setting)
                showSettingSheet = false
            }) {
                Image(systemName: "x.circle")
                    .foregroundColor(.titleTextColor)
            }
            .padding()
        }
        .background(Color.titleBackground)
    }
    
    
    
    var settingView: some View {
        GeometryReader { geo in
            HStack {
                // 샘플 보기
                Form {
                    Section {
                        VStack(alignment: .center) {
                            Text("주의 말씀의 맛이 내게 어찌 그리 단지요\n 내 입에 꿀보다 더 다니이다. \n ")
                                .tracking(setting.traking)
                                .font(.custom(setting.font.rawValue, size: setting.fontSize))
                                .lineSpacing(setting.lineSpace)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                            
                            
                            
                            Text("- 시 119:103")
                                .tracking(setting.traking)
                                .font(.custom(setting.font.rawValue, size: setting.fontSize))
                                .lineSpacing(setting.lineSpace)
                                .background(
                                    GeometryReader {            //라인 계산을 위한 base frame height
                                        Color.clear.preference(key: ViewHeightKey.self,
                                                               value: $0.frame(in: .local).size.height)
                                    })
                                .onPreferenceChange(ViewHeightKey.self) {
                                    self.setting.baseLineHeight = $0
                                }
                            
                            Spacer()
                            
                            
                            
                        }
                        .frame(height: geo.frame(in: .local).height * 0.85)
                        .padding()
                    } header: {
                        Text("Samples")
                            .tracking(2)
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .foregroundColor(.titleBackground)
                    }

                }
                .frame(width: geo.frame(in: .local).width * 0.46)
                
                Form {
                    // 글체 설정
                    Section {
                        Picker("글체", selection: $setting.font) {
                            ForEach(FontCase.allCases, id: \.self) {
                                Text($0.rawValue)
                                    .tag($0)
                            }
                        }.pickerStyle(.segmented)
                        
                    } header: {
                        Text("글체")
                            .tracking(2)
                            .font(.system(size: 15))
                            .fontWeight(.bold)
                    }
                    
                    
                    //폰트 크기 설정
                    Section {
                        Slider(value: $setting.fontSize, in: 20...35, step: 1){
                            Text("fontSize")
                        } minimumValueLabel: {
                            Text("20")
                        } maximumValueLabel: {
                            Text("35")
                        }
                        .accentColor(.titleBackground)
                        
                    } header: {
                        Text("글자 크기: \(Int(setting.fontSize))")
                            .tracking(2)
                            .font(.system(size: 15))
                            .fontWeight(.bold)
                        
                    }
                    
                    // 글자 간격
                    Section {
                        Slider(value: $setting.traking, in: 1...5, step: 1) {
                            Text("traking")
                        } minimumValueLabel: {
                            Text("1")
                        } maximumValueLabel: {
                            Text("5")
                        }
                        .accentColor(.titleBackground)
                        
                    } header: {
                        Text("글자 간격 : \(Int(setting.traking))")
                            .tracking(2)
                            .font(.system(size: 15))
                            .fontWeight(.bold)
                            .foregroundColor(.titleBackground)
                    }
                    
                    
                    // 줄 간격
                    Section {
                        Slider(value: $setting.lineSpace, in: 10...25, step: 1) {
                            Text("line spacing")
                        } minimumValueLabel: {
                            Text("10")
                        } maximumValueLabel: {
                            Text("25")
                        }
                        .accentColor(.titleBackground)
                        
                        
                    } header: {
                        Text("줄 간격 : \(Int(setting.lineSpace))")
                            .tracking(2)
                            .font(.system(size: 15))
                            .fontWeight(.bold)
                            .foregroundColor(.titleBackground)
                    }
                    
                    // 완료 버튼
                    Button(action: {
                        settingManager.updateSetting(setting: setting)
                        self.showSettingSheet.toggle()
                    }) {
                        Text("완료")
                            .fontWeight(.bold)
                            .foregroundColor(.titleBackground)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                } /// Form
            }/// HStack
        }///geometry
  
    }
    
}






struct SettinView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(setting: (SettingModel(lineSpace: 11, fontSize: 20, traking: 2)), showSettingSheet: .constant(false))
    }
}
