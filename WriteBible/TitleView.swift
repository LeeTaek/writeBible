//
//  TitleView.swift
//  WriteBible
//
//  Created by 이택성 on 2022/06/08.
//

import SwiftUI

struct TitleView: View {
    @Binding var title: BibleTitle
    @Binding var chapter: Int
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            contents
            
            bibleList

        }
    }
    
    //MARK: - 제목
    var contents: some View {
        HStack {
            Text("목차")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            Spacer()
            
            Button(action: {print("X")}) {
                Image(systemName: "x.circle")
                    .foregroundColor(.black)
                    
            }
            .padding()
            
        }
        
    }
    
    
    //MARK: - 성경 목차
    var bibleList: some View {
        let lastChapter = Bible(title: title.rawValue, chapterTitle: nil).lastChapter()
        
        return HStack {
            List {
                ForEach(BibleTitle.allCases, id: \.self) { value in
                    let ti = value.rawValue.components(separatedBy: ".").first!
                    let name = ti[4..<ti.count]
                    
                    Button(action: { self.title = value}) {
                        Text("\(name)")
                    }
                }
            }
            .listStyle(.plain)
            
            List{
                ForEach((1...lastChapter), id: \.self) { value in
                    Button(action: { self.chapter = value
                        self.presentationMode.wrappedValue.dismiss()
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
        TitleView(title: .constant(.genesis), chapter: .constant(1))
    }
}
