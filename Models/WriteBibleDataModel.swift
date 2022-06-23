////
////  WriteBibleDataModel.swift
////  WriteBible
////
////  Created by 이택성 on 2022/06/14.
////
//
//import Foundation
//import SwiftUI
//import PencilKit
//import os
//import CoreData
//
//struct DataModel: Codable  {
//    static let defaultDrawingNames: [String] = ["test writting"]
//    var id: UUID = UUID()
//    var drawings: [PKDrawing] = []
//}
//
//protocol DataModelControllerObserver{
//    func dataModelChanged()
//}
//
//
//class WriteBibleDataModel {
//    @Environment(\.managedObjectContext) private var viewContext
//    @FetchRequest(entity: Drawing.entity(), sortDescriptors: []) var drawingData: FetchedResults<Drawing>
//    
//    var dataModel = DataModel()
//
//    /// Observers add themselves to this array to start being informed of data model changes.
//    var observers = [DataModelControllerObserver]()
//
//    private let serializationQueue = DispatchQueue(label: "SerializationQueue", qos: .background)
//    
//    var drawings: [PKDrawing] {
//        get { dataModel.drawings }
//        set { dataModel.drawings = newValue }
//    }
//  
//        
//    init() {
//        print(#fileID, #function, #line, "")
//        loadDataModel()
//    }
//    
//  
//    
//    func updateDrawing(_ drawing: PKDrawing, at index: Int) {
//        saveDataModel()
//    }
//    
//    
//    
//    /// Helper method to notify observer that the data model changed.
//    private func didChange() {
//        for observer in self.observers {
//            observer.dataModelChanged()
//        }
//    }
//
//    
//    
//    /// The URL of the file in which the current data model is saved.
//    private var saveURL: URL {
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        let documentsDirectory = paths.first!
//        return documentsDirectory.appendingPathComponent("PencilKitDraw.data")
//    }
//    
//    
//    
//    /// Save the data model to persistent storage.
//    func saveDataModel() {
//        let savingDataModel = dataModel
//        let url = saveURL
//        serializationQueue.async {
//            do {
//                let encoder = PropertyListEncoder()
//                let data = try encoder.encode(savingDataModel)
//                try data.write(to: url)
//            } catch {
//                os_log("Could not save data model: %s", type: .error, error.localizedDescription)
//            }
//        }
//    }
//    
//    
//    
//    
//    /// Load the data model from persistent storage
//    private func loadDataModel() {
//        let url = saveURL
//        serializationQueue.async {
//            // Load the data model, or the initial test data.
//            let dataModel: DataModel
//            
//            if FileManager.default.fileExists(atPath: url.path) {
//                do {
//                    let decoder = PropertyListDecoder()
//                    let data = try Data(contentsOf: url)
//                    dataModel = try decoder.decode(DataModel.self, from: data)
//                } catch {
//                    os_log("Could not load data model: %s", type: .error, error.localizedDescription)
//                    dataModel = self.loadDefaultDrawings()
//                }
//            } else {
//                dataModel = self.loadDefaultDrawings()
//            }
//            
//            DispatchQueue.main.async {
//                self.setLoadedDataModel(dataModel)
//            }
//        }
//    }
//    
//    
//    
//    
//    /// Construct an initial data model when no data model already exists.
//    private func loadDefaultDrawings() -> DataModel {
//        var testDataModel = DataModel()
//        for sampleDataName in DataModel.defaultDrawingNames {
//            guard let data = NSDataAsset(name: sampleDataName)?.data else { continue }
//            if let drawing = try? PKDrawing(data: data) {
//                testDataModel.drawings.append(drawing)
//            }
//        }
//        return testDataModel
//    }
//    
//    /// Helper method to set the current data model to a data model created on a background queue.
//    private func setLoadedDataModel(_ dataModel: DataModel) {
//        self.dataModel = dataModel
//    }
//    
//    /// Create a new drawing in the data model.
//    func newDrawing() {
//        let newDrawing = PKDrawing()
//        dataModel.drawings.append(newDrawing)
//        updateDrawing(newDrawing, at: dataModel.drawings.count - 1)
//    }
//}
//
