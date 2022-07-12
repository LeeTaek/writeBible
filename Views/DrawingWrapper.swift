//
//  DrawingWrapper.swift
//  WriteBible
//
//  Created by 이택성 on 2022/06/22.
//

/*
    DrawingViewController를 SwiftUI의 View로 가져옴.

 */

import SwiftUI

struct DrawingWrapper : UIViewControllerRepresentable {
    
    typealias UIViewControllerType = DrawingViewController
    
    @ObservedObject var manager: DrawingManager
    var title: String
    
    func makeUIViewController(context: Context) -> DrawingViewController {
//        print(#fileID, #function, #line, "\(title)")
    
        save(title: title)
        
        let viewController = DrawingViewController()
        
        viewController.manager = self.manager
        viewController.drawingData = manager.getData(for: title)
        viewController.keyTitle = title
        viewController.drawingChanged = { data in
            viewController.drawingData = data
        }
        
        
        return viewController
    }
    
    /// 원래 여기서 DrawingView가 업데이트 될때마다 DB에 저장했었는데
    /// 퍼포먼스 이슈가 생겨 DrawingViewController의 viewWillDisappear에서 뷰가 사라지기 직전 Data를 DB에 저장.
    func updateUIViewController(_ uiViewController: DrawingViewController, context: Context) {
    }
    
    
    /// 뷰가 열릴 때에 해당 뷰의 PKDrawing을 저장하기 위한 RealmDB 생성
     private func save(title: String){
         manager.addData(doc: DrawingDocument(data: Data(), title: title))
     }
    
    
}
