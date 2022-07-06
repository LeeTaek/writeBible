//
//  DrawingViewController.swift
//  WriteBible
//
//  Created by 이택성 on 2022/06/22.
//

import UIKit
import PencilKit

class DrawingViewController: UIViewController {
    
    lazy var canvas: PKCanvasView = {
        var canv = PKCanvasView()
        canv.drawingPolicy = .pencilOnly
        canv.minimumZoomScale = 1
        canv.maximumZoomScale = 1
        canv.translatesAutoresizingMaskIntoConstraints = false
        return canv
    }()
    
    
    lazy var toolPicker : PKToolPicker = {
        var toolP = PKToolPicker()
        toolP.addObserver(self)
        return toolP
    }()
    
    var manager = DrawingManager()
    var drawingData = Data()
    var drawingChanged: (Data) -> Void = {_ in }
    var keyTitle: String? = ""

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(canvas)
        
        canvas.backgroundColor = UIColor.clear
        
        NSLayoutConstraint.activate([
            canvas.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            canvas.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            canvas.topAnchor.constraint(equalTo: view.topAnchor),
            canvas.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
            
        
        toolPicker.setVisible(true, forFirstResponder: canvas)
        toolPicker.addObserver(canvas)
        canvas.delegate = self
        canvas.becomeFirstResponder()
        
        if let drawing = try? PKDrawing(data: drawingData) {
            canvas.drawing = drawing
        }
    }
    
    //MARK: -  PKdrawing 저장
    override func viewWillDisappear(_ animated: Bool) {
        print(#fileID, #function, #line, "\(keyTitle!), \(drawingData)")
        manager.update(data: drawingData, for: keyTitle ?? "")
        
        let chapter = Int(String(keyTitle!.components(separatedBy: "txt").last!))!
        
        RecentWrittingManager().updateSetting(bibleTitle: keyTitle! + "txt", chapter: chapter)

    }
}

// MARK:- PK delegates
extension DrawingViewController : PKToolPickerObserver, PKCanvasViewDelegate {
    
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        drawingChanged(canvasView.drawing.dataRepresentation())
    }
}
