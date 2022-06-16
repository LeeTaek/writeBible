//
//  PKCanvas.swift
//  WriteBible
//
//  Created by 이택성 on 2022/06/08.
//

import Foundation
import PencilKit
import SwiftUI
import Introspect

struct PKCanvas: UIViewRepresentable {
    
    @Binding var canvasView: PKCanvasView

    
    let picker = PKToolPicker.init()
    
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.drawingPolicy = .pencilOnly
        
        self.canvasView.tool = PKInkingTool(.pen, color: .white, width: 15)
        self.canvasView.isOpaque = false
        self.canvasView.backgroundColor = UIColor.clear
        self.canvasView.alwaysBounceVertical = true
        self.canvasView.showsVerticalScrollIndicator = true
        
//        self.canvasView.contentSize.height = 5000
//

        return canvasView
    }
    
    
    
    

    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        picker.addObserver(canvasView)
        picker.setVisible(true, forFirstResponder: uiView)
        DispatchQueue.main.async {
            uiView.becomeFirstResponder()
        }
    }


  
}


extension PKDrawing {
    mutating func scale(in frame: CGRect) {
        var scaleFactor:CGFloat = 0
        
        if self.bounds.width != frame.width {
            scaleFactor = frame.width / self.bounds.width
        } else if self.bounds.height != frame.height {
            scaleFactor = frame.height / self.bounds.height
        }
        
        let trasform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        
        self.transform(using: trasform)
    }
}


