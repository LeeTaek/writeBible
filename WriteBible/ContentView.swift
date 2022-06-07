//
//  ContentView.swift
//  WriteBible
//
//  Created by 이택성 on 2022/06/02.
//

import SwiftUI

struct Line {
    var points = [CGPoint]()
    var color: Color = .black
    var lineWidth: Double = 1.0
}



struct ContentView: View {
    
    @State private var currentLine = Line()
    @State private var lines: [Line] = []
    
    var body: some View {
        ZStack {
            VStack {
                HStack{
                    Text("Title")
                    
                    Spacer()
                    
                    Text("Date")
                }
                            
                HStack {
                    Text("BibleView")
                    Spacer()
                    Text("writeLine")
                }
                
                Spacer()
            }//Vstack
            
            
            writeView
        }//ZStack
       
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
    
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
