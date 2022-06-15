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
    
    var canvasView: PKCanvasView
    let picker = PKToolPicker.init()
    var viewSize: CGSize
    
    
    var writeDataModel: WriteBibleDataModel!
    var drawingIndex: Int = 0
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.drawingPolicy = .pencilOnly
        
        self.canvasView.tool = PKInkingTool(.pen, color: .black, width: 15)
        self.canvasView.isOpaque = false
        self.canvasView.backgroundColor = UIColor.clear
//        self.canvasView.alwaysBounceVertical = true
        self.canvasView.showsVerticalScrollIndicator = true

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



class CanvasViewController: UIHostingController<PKCanvas> {
    override func viewDidAppear(_ animated: Bool) {
       
        super.viewDidAppear(animated)
        
        let canvasViews = self.view.get(all: PKCanvasView.self)
        
        guard let cv = canvasViews.first,
              let pinch = cv.pinchGestureRecognizer else {
            assertionFailure()
            return
        }
        
        self.view.addGestureRecognizer(pinch)
            self.view.addGestureRecognizer(cv.drawingGestureRecognizer)
    // TODO: add pan and maybe the lasso recognizers mentioned in earlier reply.
        }
}

/// Note: UIView.get is based on a StackOverflow post.
/// [Vasily Bodnarchuk's Answer](https://stackoverflow.com/questions/32301336/swift-recursively-cycle-through-all-subviews-to-find-a-specific-class-and-appen)
/// 참고 :https://www.reddit.com/r/SwiftUI/comments/of6pxp/pkcanvasview_with_overlay/h4dqt2g/


extension UIView {

    class func getAllSubviews<T: UIView>(from parenView: UIView) -> [T] {
        return parenView.subviews.flatMap { subView -> [T] in
            var result = getAllSubviews(from: subView) as [T]
            if let view = subView as? T { result.append(view) }
            return result
        }
    }

    class func getAllSubviews(from parenView: UIView, types: [UIView.Type]) -> [UIView] {
        return parenView.subviews.flatMap { subView -> [UIView] in
            var result = getAllSubviews(from: subView) as [UIView]
            for type in types {
                if subView.classForCoder == type {
                    result.append(subView)
                    return result
                }
            }
            return result
        }
    }

    func getAllSubviews<T: UIView>() -> [T] { return UIView.getAllSubviews(from: self) as [T] }
    func get<T: UIView>(all type: T.Type) -> [T] { return UIView.getAllSubviews(from: self) as [T] }
    func get(all types: [UIView.Type]) -> [UIView] { return UIView.getAllSubviews(from: self, types: types) }
}
