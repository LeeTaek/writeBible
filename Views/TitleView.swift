//
//  TitleView.swift
//  WriteBible
//
//  Created by 이택성 on 2022/06/08.
//

import SwiftUI

struct TitleView: View {
    @Binding var bibleTitle: BibleTitle
    @Binding var chapter: Int
    @Binding var showTitleSheet: Bool

    var body: some View {
            title
    }
    
    
    
    
    //MARK: - Title View
    var title: some View {
        let ti = bibleTitle.rawValue.components(separatedBy: ".").first!
        let name = ti[4..<ti.count]
        
        return HStack{
            
            Button("\(name) \(chapter)장") {
                        self.showTitleSheet.toggle()
                    }
                    .font(.system(size: 30))
                    .padding()
                    .sheet(isPresented: $showTitleSheet) {
                        VStack {
                            contents
                            
                            bibleList
                                .padding()
                        }
                    }
            
            Spacer()

        }
    }
    
    
    
    
    //MARK: - Sheet창의 성경 제목
    var contents: some View {
        HStack {
            Text("목차")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            Spacer()
            
            Button(action: {
                showTitleSheet = false
            }) {
                Image(systemName: "x.circle")
                    .foregroundColor(.black)
                    
            }
            .padding()
            
        }
        
    }
    
    
    //MARK: - Sheet창의 장
    var bibleList: some View {
        let lastChapter = Bible(title: bibleTitle.rawValue, chapterTitle: nil).lastChapter()
        
        return HStack {
            List {
                ForEach(BibleTitle.allCases, id: \.self) { value in
                    let ti = value.rawValue.components(separatedBy: ".").first!
                    let name = ti[4..<ti.count]
                    
                    Button(action: { self.bibleTitle = value}) {
                        Text("\(name)")
                    }
                }
            }
            .listStyle(.plain)
            
            List{
                ForEach((1...lastChapter), id: \.self) { value in
                    Button(action: { self.chapter = value
                        showTitleSheet = false

                    }) {
                        Text("\(value)")
                    }
                }
            }.listStyle(.plain)
        }
    }
    
    
    
}

struct TitleView_Previews: PreviewProvider {
   
    
    static var previews: some View {
        TitleView(bibleTitle: .constant(.genesis), chapter: .constant(1),showTitleSheet: .constant(false))
    }
}
