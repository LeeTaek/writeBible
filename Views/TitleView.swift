//
//  TitleView.swift
//  WriteBible
//
//  Created by 이택성 on 2022/06/08.
//

import SwiftUI
import RealmSwift

struct TitleView: View {    
    
    @Binding var bibleTitle: BibleTitle
    @Binding var chapter: Int
    @Binding var showTitleSheet: Bool
    @State private var showTitle = false
    @State var showiSettingSheet = !SettingManager().isEmpty()  // setting 초기 설정을 위한 변수
    @ObservedRealmObject var settingValue: SettingManager

    @Environment(\.colorScheme) var colorScheme     // Dark모드에서 새기다 버튼 컬러를 위해 모드 감지


    var body: some View {
        VStack {
            title
            Spacer()
        }
    }
    
    
    //MARK: - Title View
    var title: some View {
        let ti = bibleTitle.rawValue.components(separatedBy: ".").first!
        let name = ti[4..<ti.count]
        
        return HStack{
            //MARK: -  Title 창
            Button(action: {
                self.showTitleSheet.toggle()
            }) {
                
                Text("\(name) \(chapter)장")
                    .font(.system(size: 30))
                    .padding()
                    .foregroundColor(.titleTextColor)
            }
            .sheet(isPresented: $showTitleSheet) {
                VStack {
                    contents
                    
                    bibleList
                        .padding()
                }
            }


            Spacer()
            
            
            //MARK: - 설정창 sheet
            Button(action: {self.showiSettingSheet.toggle()}) {
                Image(systemName: "gearshape")
                    .foregroundColor(Color.titleTextColor)
                    .padding()
                    
            }.sheet(isPresented: $showiSettingSheet) {
                // 앱 처음 실행시 셋팅값이 없다면 setting 창을 띄워준다.
                SettingView(setting: settingValue.getSetting(), showSettingSheet: $showiSettingSheet)
            }

            
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
           
            Button(action: {
                showTitleSheet = false
            }) {
                Image(systemName: "x.circle")
                    .foregroundColor(.titleTextColor)
                    
            }
            .padding()
        }
        .background(Color.titleBackground)

        
    }
    
    
    //MARK: - Sheet창의 장
    var bibleList: some View {
        let lastChapter = Bible(title: bibleTitle.rawValue).getLastChapter()

        return HStack {
            // 성경 책 리스트
            List {
                ForEach(BibleTitle.allCases, id: \.self) { value in
                    let ti = value.rawValue.components(separatedBy: ".").first!
                    let name = ti[4..<ti.count]
                    
                    Button(action: {
                        self.bibleTitle = value
                        
                    }) {
                        VStack {
                            Text("\(name)")
                        }
                    }
                    .listRowBackground(self.bibleTitle == value ? Color.selectedColor : Color(UIColor.systemBackground))
                }

            }
            .listStyle(.plain)
            
            // 성경 구절 리스트
            List{
                ForEach((1...lastChapter), id: \.self) { value in
                    Button(action: {
                        self.chapter = value

                        showTitleSheet = false

                    }) {
                        HStack {
                            Text("\(value)")
                            
                            Spacer()
                            
                            if RealmManager().isWirtten(title: bibleTitle.rawValue, chapter: value) {
                                Image("Pencil")
                                    .resizable()
                                    .renderingMode(.template)
                                    .frame(width: 30, height:30)
                                    .tint(colorScheme == .light ? Color.black.opacity(0.85) : Color.white.opacity(0.85))
                            }
                       
                        }
                    }
                    .listRowBackground(self.chapter == value ? Color.selectedColor : Color(UIColor.systemBackground))
                }
                
            }.listStyle(.plain)
        }
    }
    
    
    
    
    
}


struct TitleView_Previews: PreviewProvider {
   static var previews: some View {
       TitleView(bibleTitle: .constant(.genesis), chapter: .constant(1),showTitleSheet: .constant(true), settingValue: SettingManager())
    }
}

