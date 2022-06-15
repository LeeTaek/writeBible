//
//  ContentView.swift
//  WriteBible
//
//  Created by 이택성 on 2022/06/02.
//

import SwiftUI
import PencilKit

//View의 크기를 알기위해 사용하는 변수
struct sizePreferenceKey: PreferenceKey{
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}



struct ContentView: View {
    @State var bibleTitle: BibleTitle = .genesis
    @State var chapterNum: Int = 1
    @State private var showingSheet = false
    @State var showingWriteView = false
    @State private var canvasView = PKCanvasView()
    @Environment (\.managedObjectContext) var viewContext
    
    
    //사용하는 메인뷰의 높이를 구하기위해 사용하는 변수
    @State var writeViewSize : CGSize = .zero
    
    // 제스처 상태를 임시 저장하는 용도.
    @State private var offset: CGSize = .zero

    var body: some View {
        let drag = DragGesture()
                   .onChanged { self.offset = $0.translation }
//                   .onEnded { _ in self.offset = .zero }
        
        return VStack {
            
            title
            
            
            writeView
                    .overlay() {
                        if showingWriteView {
                            PKCanvas(canvasView: canvasView, viewSize: self.writeViewSize)
                                .gesture(drag)
                        }
                    }
            
                            
              
            
            
           
        }
    }
    

    
    
    //MARK: - Title View
    var title: some View {
        let ti = bibleTitle.rawValue.components(separatedBy: ".").first!
        let name = ti[4..<ti.count]
        
        return HStack{
            
            Button("\(name) \(chapterNum)장") {
                        self.showingSheet.toggle()
                    }
                    .font(.system(size: 30))
                    .padding()
                    .sheet(isPresented: $showingSheet) {
                        TitleView(title: $bibleTitle, chapter: $chapterNum)
                    }
            
            Spacer()
            
            Button {
                self.showingWriteView.toggle()
            } label: {
                Image(systemName: "pencil")
                    .font(.system(size: 20))
                    .padding()
            }
        }
    }
    
   
    
    
    //MARK: - 성경 본문 view
    var writeView: some View {
        let bible = Bible(title: bibleTitle.rawValue, chapterTitle: nil)

        return GeometryReader { geo in
            List(bible.makeBible(title: bibleTitle.rawValue).filter{$0.chapter == chapterNum}, id: \.sentence ) { name in
                HStack (alignment: .top){
                    // 성경 구절
                    BibleView(bibleSentence: name)
                        .frame(width: geo.size.width/2, alignment: .leading)

                             
                    // 필사 뷰 절
                    Text("\(name.section)")
                        .bold()
                        .font(.system(size: 17))

                    
                    // 필사하는 부분 line
                    LazyVStack (alignment: .leading, spacing: 30){
                        ForEach(1..<5, id: \.self) { _ in
                            Rectangle()
                              .opacity(0.2)
                              .frame(width: geo.size.width/5 * 2, height: 2)
                              .position(x: 180,y: 22)
                        }
                    }
                    
                }
                .padding([.bottom])
                .listRowSeparator(.hidden)
            }
            .background(
                              //SwiftUI 에서는 각 뷰의 크기를 구하는것이 함수화 되어있지않다 그래서 살짝 꼼수를 사용해야하는데
                              //내가 상단으로 인지하고싶은 부분에 투명한 색상의 배경을 하나 선언을 해주고
                              //선언한 투명한 배경의 크기를 구한다.

                              //그때 필요한것이 바로 sizePreferenceKey
                              GeometryReader { proxy in
                                  Color.clear
                                      .preference(key: sizePreferenceKey.self, value: proxy.size)
                              }
                          )
                          //SizePreferenceKey.self 값이 변경될때마다 실행되는 트리거를 실행하고
                          //이렇게 구한 화면의 크기를 heigtVStackMain 변수에 넣어준다.
                          .onPreferenceChange(sizePreferenceKey.self){ newSize in
                              self.writeViewSize = newSize
                              print("높이 :  \(self.writeViewSize)")
                          }
            .listStyle(.plain)
                .coordinateSpace(name: "sentenceView")
            
        }
    }
    
 
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

