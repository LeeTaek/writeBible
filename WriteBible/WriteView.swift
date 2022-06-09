//
//  WriteView.swift
//  WriteBible
//
//  Created by 이택성 on 2022/06/08.
//

import SwiftUI
import PencilKit


struct WriteView: View {
    
    @Environment(\.undoManager) private var undoManager
    @State private var canvasView = PKCanvasView()
    
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                Button(action: { canvasView.drawing = PKDrawing() } ) {
                    Image(systemName: "trash")
                }
                
                Button(action: { undoManager?.undo() } ) {
                    Image(systemName: "arrow.uturn.backward")
                }
                
                Button(action: { undoManager?.redo() } ) {
                    Image(systemName: "arrow.uturn.forward")
                }
         
            }
            
            PKCanvas(canvasView: $canvasView)
        }
        
    }
    
    
   
        
    
}

struct WriteView_Previews: PreviewProvider {
    static var previews: some View {
        WriteView()
    }
}
