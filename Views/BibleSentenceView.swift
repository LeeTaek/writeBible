//
//  BibleView.swift
//  WriteBible
//
//  Created by 이택성 on 2022/06/07.
//

import SwiftUI

struct BibleSentenceView: View {
    var bibleSentence: Bible
    
    var body: some View {
        HStack(alignment: .top) {
            Text("\(bibleSentence.section)")
                .bold()
                .font(.system(size: 18))

            Text("\(bibleSentence.sentence)")
                .tracking(3)
                .font(.system(size: 17))
                .lineSpacing(10) //텍스트 줄간격 조절
            
        }
        .padding([.trailing,.leading])
    }
    
    var test : some View  {
        Text("\(bibleSentence.sentence)")
            .tracking(3)
            .font(.system(size: 17))
            .lineSpacing(10) //텍스트 줄간격 조절    }
            .coordinateSpace(name: "test")
    }
}

struct BibleSentenceView_Previews: PreviewProvider {

    static var previews: some View {
        let bible = Bible(title: "창세기", chapterTitle: nil, chapter: 1, section: 1, sentence: "[수5:1] 요단 서쪽의 아모리 사")
        
        
        BibleSentenceView(bibleSentence: bible)
    }
}
