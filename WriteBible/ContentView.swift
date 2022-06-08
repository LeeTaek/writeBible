//
//  ContentView.swift
//  WriteBible
//
//  Created by 이택성 on 2022/06/02.
//

import SwiftUI
import RealmSwift

struct Line {
    var points = [CGPoint]()
    var color: Color = .black
    var lineWidth: Double = 1.0
}



struct ContentView: View {
    
    @State private var currentLine = Line()
    @State private var lines: [Line] = []
    @State var bibleTitle: BibleTitle = .genesis

    
    var body: some View {
        VStack {
            HStack{
                //MARK: - Title
                Picker("성경본문", selection: $bibleTitle) {
                    ForEach(BibleTitle.allCases, id: \.self) {
                        Text($0.rawValue)
                            .tag($0)
                    }
                }
                
                Spacer()
                
                Image(systemName: "pencil")
                
            }
    

            HStack {
                GeometryReader {
                        sen
                        .frame(width: $0.size.width / 2)
 
                }
            }
        }//Vstack
    }
    

    
    
    
    //MARK: - WriteView
    var writeView: some View {
        Canvas { context, size in
            
            for line in lines {
                var path = Path()
                path.addLines(line.points)
                context.stroke(path, with: .color(line.color), lineWidth: line.lineWidth)
            }
            
        }.gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged({ value in
                let newPoint = value.location
                
                currentLine.points.append(newPoint)
                self.lines.append(currentLine)
            })
                .onEnded({ value in
                    self.currentLine = Line(points: [])
                })
        )
        .background(.red.opacity(0))
    }
    
    
    
    //MARK: - 성경 본문 view
    var sen: some View {
        let bible = Bible(title: bibleTitle.rawValue, chapterTitle: nil)
        
        return List(bible.makeBible(title: bibleTitle.rawValue).filter{$0.chapter == 1}, id: \.sentence ) {
               BibleView(bibleSentence: $0)
                .listRowSeparator(.hidden)
        }.listStyle(.plain)
            .padding()
        
    }
 
    
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}




