//
//  BibleView.swift
//  WriteBible
//
//  Created by 이택성 on 2022/06/16.
//

import SwiftUI
import PencilKit
import SimultaneouslyScrollView
import Introspect
import Combine

struct BibleView: View {
    @Binding var bibleTitle: BibleTitle
    @Binding var chapterNum: Int
    @State private var canvasView = PKCanvasView()

    //사용하는 메인뷰의 높이를 구하기위해 사용하는 변수
    @State var writeViewSize : CGSize = .zero
    
    
    // 동시 스크롤을 위한 객체 생성.
    let simultaneouslyScrollViewHandler = SimultaneouslyScrollViewHandlerFactory.create()
    
    
    var body: some View {
        simultaneouslyScrollViewHandler.register(scrollView: canvasView)
        
        return writeView
            .introspectScrollView { simultaneouslyScrollViewHandler.register(scrollView: $0) }      // 동시 스크롤을 위한 동기화
            .overlay() {
                    PKCanvas(canvasView: $canvasView, canvasSize: $writeViewSize)
            }
    }
    
    
    
    //MARK: - 성경 본문 view
    var writeView: some View {
        let bible = Bible(title: bibleTitle.rawValue, chapterTitle: nil)

        return GeometryReader { geo in
            ScrollView(.vertical) {
                    ForEach(bible.makeBible(title: bibleTitle.rawValue).filter{$0.chapter == chapterNum}, id: \.sentence ) { name in
                        HStack (alignment: .top){
                            // 성경 구절
                            BibleSentenceView(bibleSentence: name)
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
                            }/// LazyVStack
                            
                        }
                        .padding([.bottom])
                        .listRowSeparator(.hidden)
                    } /// list
                    .background(    // DrawView에 넘길 전체 사이즈 설정
                        GeometryReader { proxy in
                            Color.clear
                                .onAppear() {
                                    self.writeViewSize = proxy.size     // 초기값
                                    print(self.writeViewSize)
                                }
                                .valueChanged(value: chapterNum) { value  in        // 변할 떄에 값
                                    self.writeViewSize = proxy.size
                                    print(self.writeViewSize)
                                }
                        }
                    )
                    .listStyle(.plain)
            } /// scrollView
        } /// geometry
    }
    
    
}

struct BibleView_Previews: PreviewProvider {
    
    static var previews: some View {
        BibleView(bibleTitle: .constant(.genesis), chapterNum: .constant(1))
    }
}


extension View {
    @ViewBuilder func valueChanged<T: Equatable>(value: T, onChange: @escaping (T) -> Void) -> some View {
        if #available(iOS 14.0, *) {
            self.onChange(of: value, perform: onChange)
        } else {
            self.onReceive(Just(value)) { (value) in
                onChange(value)
            }
        }
    }
}
