//
//  DrawingView.swift
//  WriteBible
//
//  Created by 이택성 on 2022/06/20.
//

import SwiftUI
import CoreData
import PencilKit

struct DrawingCanvasView: UIViewControllerRepresentable {
    @Environment(\.managedObjectContext) private var viewContext
    
    typealias UIViewControllerType = DrawingCanvasViewController
    
    var data: Data
    var id: UUID
    
    func makeUIViewController(context: Context) -> DrawingCanvasViewController {
        let viewController = DrawingCanvasViewController()
        let request: NSFetchRequest<Drawing> = Drawing.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.predicate = predicate
        
        viewController.drawingData = data
        viewController.drawingChanged = { data in

            do {
                let result = try viewContext.fetch(request)
                let obj = result.first
                obj?.setValue(data, forKey: "canvasData")
                do {
                    try viewContext.save()
                } catch {
                    print(error)
                }
            }
            catch {
                print(error)
            }
        }
        
        return viewController
    }
    

    func updateUIViewController(_ uiViewController: DrawingCanvasViewController, context: Context) {
        uiViewController.drawingData = data
    }
    
    
    
    
    
    
}
