//
//  PKCanvas.swift
//  WriteBible
//
//  Created by 이택성 on 2022/06/08.
//

import Foundation
import PencilKit
import SwiftUI
import RealmSwift

struct PKCanvas: UIViewRepresentable {
    
    @Binding var canvasView: PKCanvasView
    let picker = PKToolPicker.init()
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.drawingPolicy = .default
        self.canvasView.tool = PKInkingTool(.pen, color: .red, width: 15)
        self.canvasView.becomeFirstResponder()
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
