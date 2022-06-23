//
//  DrawingWrapper.swift
//  WriteBible
//
//  Created by 이택성 on 2022/06/22.
//

import SwiftUI

struct DrawingWrapper : UIViewControllerRepresentable {
    
    typealias UIViewControllerType = DrawingViewController
    
    @ObservedObject var manager: DrawingManager
    var title: String
    
    func makeUIViewController(context: Context) -> DrawingViewController {
        print(#fileID, #function, #line, "\(title)")
                
        let viewController = DrawingViewController()
        
        viewController.manager = self.manager
        viewController.drawingData = manager.getData(for: title)
        viewController.keyTitle = title
        viewController.drawingChanged = { data in
            viewController.drawingData = data
        }
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: DrawingViewController, context: Context) {
    }
}
