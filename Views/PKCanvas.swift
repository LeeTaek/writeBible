//
//  PKCanvas.swift
//  WriteBible
//
//  Created by 이택성 on 2022/06/08.
//

import Foundation
import PencilKit
import SwiftUI
import CoreData


struct PKCanvas: UIViewRepresentable {
    @Environment(\.managedObjectContext) private var viewContext

    @Binding var canvasView: PKCanvasView
    @Binding var canvasSize: CGSize
//    @Binding var data: PKDrawing
   
    
    
    let picker = PKToolPicker.init()

    /// Data model for the drawing displayed by this view controller.
    var dataModelController = WriteBibleDataModel()
    
    /// Private drawing state.
    var drawingIndex: Int = 0
    var hasModifiedDrawing = false
    
    
    
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.drawingPolicy = .pencilOnly
        
        self.canvasView.tool = PKInkingTool(.pen, color: .white, width: 15)
        self.canvasView.isOpaque = false
        self.canvasView.backgroundColor = UIColor.clear
        self.canvasView.alwaysBounceVertical = true
        self.canvasView.showsVerticalScrollIndicator = true
        
        self.canvasView.minimumZoomScale = 0.5
        self.canvasView.maximumZoomScale = 1.5
        self.canvasView.translatesAutoresizingMaskIntoConstraints = true

        
        return canvasView
    }
    
    
    
    

    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        self.canvasView.contentSize = self.canvasSize
        
        picker.addObserver(canvasView)
        picker.setVisible(true, forFirstResponder: uiView)
        DispatchQueue.main.async {
            uiView.becomeFirstResponder()
        }
        
        dataModelController.updateDrawing(canvasView.drawing, at: drawingIndex)
        self.canvasView.drawing = dataModelController.drawings[drawingIndex]
    }

    
    
    
    func setCanvasDrawing(data drawingData: Data? = nil, height: Double) {
        if let data = drawingData { canvasView.drawing = try! PKDrawing(data: data)}
        if height == 0 {
            canvasView.contentSize.height = UIScreen.main.bounds.height
        } else {
            canvasView.contentSize.height = height
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


