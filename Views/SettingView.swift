//
//  SettingView.swift
//  WriteBible
//
//  Created by 이택성 on 2022/06/27.
//

import SwiftUI

struct SettingView: View {
    @Binding var setting: SettingModel
    @Binding var showSettingSheet: Bool
    
    var body: some View {
        VStack {
            Text("Samples ")
                .tracking(setting.traking)
                .font(.system(size: setting.fontSize))
                .lineSpacing(setting.lineSpace) //텍스트 줄간격 조절
                .background(
                    GeometryReader {      // << set right side height
                               Color.clear.preference(key: ViewHeightKey.self,
                                   value: $0.frame(in: .local).size.height)
                   })
                .onPreferenceChange(ViewHeightKey.self) { // << read right side height
                    self.setting.baseLineHeight = $0        // << here !!
                   }
            
            Text(" 태초에 하나님이 천지를 창조하시니라 ")
                .tracking(setting.traking)
                .font(.system(size: setting.fontSize))
                .lineSpacing(setting.lineSpace) //텍스트 줄간격 조절
            
            Button(action: {self.showSettingSheet.toggle()}) {
                Text("완료")
            }
        }
  
    }
}

struct SettinView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(setting: .constant(SettingModel(lineSpace: 11, fontSize: 20, traking: 2)), showSettingSheet: .constant(false))
    }
}
