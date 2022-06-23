//
//  PKCanvas.swift
//  WriteBible
//
//  Created by 이택성 on 2022/06/08.
//

import Foundation
import PencilKit
import SwiftUI




struct PKCanvas: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView
    @Binding var canvasSize: CGSize

    let picker = PKToolPicker.init()
    var manager: DrawingManager
    var title: String
    
    func makeUIView(context: Context) -> PKCanvasView {
        print(#fileID, #function, #line, "")
        canvasView.drawingPolicy = .pencilOnly
        
        
        self.canvasView.tool = PKInkingTool(.pen, color: .white, width: 15)
        self.canvasView.isOpaque = false
        self.canvasView.backgroundColor = UIColor.clear
        self.canvasView.alwaysBounceVertical = true
        self.canvasView.showsVerticalScrollIndicator = true
        
        if let drawing = try? PKDrawing(data: manager.getData(for: title)) {
            canvasView.drawing = drawing
        }

        return canvasView
    }
    

    

    func updateUIView(_ uiView: PKCanvasView, context: Context) {
//        print(#fileID, #function, #line, "viewChanged: \(title)")
        self.canvasView.contentSize = self.canvasSize
    
        picker.addObserver(canvasView)
        picker.setVisible(true, forFirstResponder: uiView)
    
//        uiView.delegate = context.coordinator
        
        DispatchQueue.main.async {
            uiView.becomeFirstResponder()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PKCanvasViewDelegate {
        let parent: PKCanvas

        init(_ canvas: PKCanvas) {
            self.parent = canvas
        }

        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            parent.manager.update(data: canvasView.drawing.dataRepresentation(), for: parent.title)
        }

    }
    
}





//
//
//extension PKDrawing {
//    mutating func scale(in frame: CGRect) {
//        var scaleFactor:CGFloat = 0
//
//        if self.bounds.width != frame.width {
//            scaleFactor = frame.width / self.bounds.width
//        } else if self.bounds.height != frame.height {
//            scaleFactor = frame.height / self.bounds.height
//        }
//
//        let trasform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
//
//        self.transform(using: trasform)
//    }
//}
//
//
