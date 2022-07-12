//
//  DrawingViewController.swift
//  WriteBible
//
//  Created by 이택성 on 2022/06/22.
//

import UIKit
import PencilKit

class DrawingViewController: UIViewController {
    
    // PKCanvasView
    lazy var canvas: PKCanvasView = {
        var canv = PKCanvasView()
        canv.drawingPolicy = .pencilOnly
        canv.minimumZoomScale = 1
        canv.maximumZoomScale = 1
        canv.translatesAutoresizingMaskIntoConstraints = false
        return canv
    }()
    
    // PKToolPicker
    lazy var toolPicker : PKToolPicker = {
        var toolP = PKToolPicker()
        toolP.addObserver(self)
        return toolP
    }()
    
    var manager = DrawingManager()      // 그린 내용을 저장하기 위한 프로퍼티
    var drawingData = Data()            // ViewWillDisappear때에 DB에 저장하기 위해 새로 그린 DB들을 모아둘 변수. Buffer.
    var drawingChanged: (Data) -> Void = {_ in }        // 새로 그린 PKdrawing의 데이털르 DrawingData에 넣는 메소드. DrawingWrapper에서 정의
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
//        print(#fileID, #function, #line, "\(keyTitle!), \(drawingData)")
        // Drawing Data 저장
        manager.update(data: drawingData, for: keyTitle ?? "")
        
        // 다음 앱 실행 때 마지막 작성하던 곳을 열어주기 위해 쓰던 페이지 항목 저장
        let chapterNum = Int(String(keyTitle!.components(separatedBy: "txt").last!))!
        let title = keyTitle!.components(separatedBy: "txt").first! + "txt"
        RecentWritingManager().updateSetting(bibleTitle: title, chapter: chapterNum)

    }
}

// MARK:- PK delegates
extension DrawingViewController : PKToolPickerObserver, PKCanvasViewDelegate {
    //MARK: - canvas에 새로 그린 내용들 체크
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        drawingChanged(canvasView.drawing.dataRepresentation())
    }
}
