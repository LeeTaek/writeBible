//
//  DrawingViewController.swift
//  WriteBible
//
//  Created by 이택성 on 2022/06/20.
//

import SwiftUI
import PencilKit

class DrawingCanvasViewController: UIViewController {
    
    lazy var canvas: PKCanvasView = {
        let view = PKCanvasView()
        view.drawingPolicy = .pencilOnly
        view.minimumZoomScale = 1
        view.maximumZoomScale = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    lazy var toolPicker: PKToolPicker = {
        let toolPicker = PKToolPicker()
        toolPicker.addObserver(self)
        return toolPicker
    }()
    
    var drawingData = Data()
    var drawingChanged: (Data) -> Void = {_ in}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(canvas)
        canvas.backgroundColor = UIColor.clear
        canvas.contentSize = CGSize(width: 1024, height: 5000)
        
        NSLayoutConstraint.activate([
                                        canvas.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                        canvas.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                        canvas.topAnchor.constraint(equalTo: view.topAnchor),
                                        canvas.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
        toolPicker.setVisible(true, forFirstResponder: canvas)
        toolPicker.addObserver(canvas)
        canvas.delegate = self
        canvas.becomeFirstResponder()
        if let drawing = try? PKDrawing(data: drawingData){
            canvas.drawing = drawing
        }
    }
}



extension DrawingCanvasViewController:PKToolPickerObserver, PKCanvasViewDelegate{
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        drawingChanged(canvasView.drawing.dataRepresentation())
    }
}


