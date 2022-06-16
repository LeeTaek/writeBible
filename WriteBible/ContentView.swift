//
//  ContentView.swift
//  WriteBible
//
//  Created by 이택성 on 2022/06/02.
//

import SwiftUI
import PencilKit
import SimultaneouslyScrollView
import Introspect

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
//    @Environment (\.managedObjectContext) var viewContext
    
    //사용하는 메인뷰의 높이를 구하기위해 사용하는 변수
    @State var writeViewSize : CGFloat = .zero
    
    // 동시 스크롤을 위한 객체 생성.
    let simultaneouslyScrollViewHandler = SimultaneouslyScrollViewHandlerFactory.create()
    
    
    var body: some View {
        simultaneouslyScrollViewHandler.register(scrollView: canvasView)
        
   
        return VStack {
            title
        
            
            BibleView(bibleTitle: $bibleTitle, chapterNum: $chapterNum)
                .introspectScrollView { simultaneouslyScrollViewHandler.register(scrollView: $0) }      // 동시 스크롤을 위한 동기화
                .overlay() {
                    PKCanvas(canvasView: $canvasView)
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
    
   
    
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

