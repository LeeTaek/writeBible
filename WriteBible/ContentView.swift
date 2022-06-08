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
        ZStack {
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
       
                
                Spacer()
            }//Vstack
            
            
//            writeView
        }//ZStack
       
    }
    
//
//    var BibleTitleView: some View {
//        Picker
//    }
//    
    
    
    
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
                
        List(makeBible(title: bibleTitle.rawValue).filter{$0.chapter == 1}, id: \.sentence ) {
               BibleView(bibleSentence: $0)
                .listRowSeparator(.hidden)

        }.listStyle(.plain)
            .padding()
    }
 
    
    
    
    
    
    
    
    //MARK: - fileRead
    func fileRead(title: String) -> [String] {
        // 파일 경로
        let textPath = Bundle.main.path(forResource: "\(title)", ofType: nil)
        // 한글 인코딩
        let encodingEUCKR = CFStringConvertEncodingToNSStringEncoding(0x0422)

        // 각 절
        var genesis = [String]()

        // 파일 읽기
        do {
            let contents = try String(contentsOfFile: textPath!, encoding: String.Encoding(rawValue: encodingEUCKR))
            genesis = contents.components(separatedBy: "\r")

        } catch let e {
            print(e.localizedDescription)
        }
        
        return genesis
    }
    
    
    
    
    
    //MARK: - 바이블 객체 생성
    func makeBible(title: String) -> [Bible] {
        let str = fileRead(title: title)
        var bible = [Bible]()
        
        str.forEach{
            var prefix = ""
            var surfix = ""
            
            for i in 0..<$0.count {
                if $0[i] == " " {
                    prefix = $0[0..<i]
                    surfix = $0[i+1..<$0.count]
                    break
                }
            }
            
            guard let chapter = Int(prefix.components(separatedBy: ":").first!) else {return}
            guard let section = Int(prefix.components(separatedBy: ":").last!) else {return}
            
         
            bible.append(Bible(title: title, chapterTitle: nil, chapter: chapter, section: section, sentence: surfix))
        }
        
        return bible
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}





// String Extention
extension String {
    subscript(_ index: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: index)]
    }
    
    subscript(_ range: Range<Int>) -> String {
         let fromIndex = self.index(self.startIndex, offsetBy: range.startIndex)
         let toIndex = self.index(self.startIndex,offsetBy: range.endIndex)
         return String(self[fromIndex..<toIndex])
     }
}
