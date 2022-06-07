//
//  BibleView.swift
//  WriteBible
//
//  Created by 이택성 on 2022/06/07.
//

import SwiftUI

struct BibleView: View {
    var bibleSentence: Bible
    
    var body: some View {

        HStack(alignment: .top) {
            Text("\(bibleSentence.section)")
                .bold()
                .font(.system(size: 16))
            
            Text("\(bibleSentence.sentence)")
                .tracking(3)
                .font(.system(size: 15))

        }
    }
}

struct BibleView_Previews: PreviewProvider {

    static var previews: some View {
        var bible = Bible(title: "창세기", chapterTitle: nil, chapter: 1, section: 1, sentence: "태초에 하나님이 천지를 창조하시니라")
        
        
        BibleView(bibleSentence: bible)
    }
}
