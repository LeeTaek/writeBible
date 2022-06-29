//
//  BibleView.swift
//  WriteBible
//
//  Created by 이택성 on 2022/06/07.
//

import SwiftUI

struct BibleSentenceView: View {
    var bibleSentence: Bible
    
    ///사용하는 메인뷰의 높이를 구하기위해 사용하는 변수
    @State var textHeight : CGFloat = .zero
    @State var line: Int = 3
    @Binding var setting: SettingModel
    
    var LineHeight: CGFloat = .zero
    
    var body: some View {
        let chapter = bibleSentence.section > 9 ? bibleSentence.section.description : bibleSentence.section.description + "  "
        
        return GeometryReader { geo in
                HStack(alignment: .top) {
                    Text(chapter)
                        .bold()
                        .font(.system(size: setting.fontSize + 1))

                    
                    Text("\(bibleSentence.sentence)")
                        .tracking(setting.traking)
                        .font(.system(size: setting.fontSize))
                        .lineSpacing(setting.lineSpace) //텍스트 줄간격 조절
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(width: geo.frame(in: .global).size.width/7 * 3, alignment: .leading)
                        .background(
                            GeometryReader {      // << set right side height
                                       Color.clear.preference(key: ViewHeightKey.self,
                                           value: $0.frame(in: .local).size.height)
                           })
                    
                    // 필사 뷰 절 번호
                    Text(chapter)
                        .bold()
                        .font(.system(size: setting.fontSize + 1))
                        


                    // 필사하는 부분 line
                    VStack (alignment: .leading, spacing: 30){
                        ForEach(1..<line, id: \.self) { _ in
                            Rectangle()
                              .opacity(0.2)
                              .frame(width: geo.frame(in: .local).size.width/7 * 3, height: 2)
                              .position(x: (geo.frame(in: .local).midX + geo.frame(in: .local).minX)/2 - 20 , y: geo.frame(in: .local).minY + setting.fontSize + (setting.lineSpace*0.5))
                        }
                    }
                }///HStack
                .onPreferenceChange(ViewHeightKey.self) {
                    // Frame 높이에 따라 그릴 Line 수 계산
                    self.textHeight = $0
                    self.line = Int((textHeight + 1 + setting.lineSpace) / (setting.baseLineHeight + setting.lineSpace)) + 1
//                    print("chapter: \(chapter), height: \($0), line: \(self.line)")
//                    print("space: \(setting.lineSpace), baseheight: \(setting.baseLineHeight)")
                   }
                .padding([.trailing,.leading])
        }.frame(height: self.textHeight)
    }

     
}


struct BibleSentenceView_Previews: PreviewProvider {

    static var previews: some View {
        let bible = Bible(title: "요한계시록", chapter: 4, section: 1, sentence: "이 일 후에 내가 보니 하늘에 열린 문이 있는데 내가 들은 바 처음에 내게 말하던 나팔 소리 같은 그 음성이 이르되 이리로 올라오라 이 후에 마땅히 일어날 일들을 내가 네게 보이리라 하시더라")
        
        
        BibleSentenceView(bibleSentence: bible, setting: .constant(SettingModel(lineSpace: 11, fontSize: 20, traking: 2)))
    }
}


/// https://stackoverflow.com/questions/66485411/dynamic-texteditor-overlapping-with-other-viewㄴ
struct ViewHeightKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}
