//
//  WriteBibleDataModel.swift
//  WriteBible
//
//  Created by 이택성 on 2022/06/14.
//

import Foundation
import PencilKit
import os

struct DataModel: Codable {
    
    static let defaultDrawingNames: [String] = ["Writting"]
    
    var drawings: [PKDrawing] = []
}

protocol DataModelControllerObserver{
    func dataModelChanged()
}


class WriteBibleDataModel {
    var dataModel = DataModel()
    
    var observers = [DataModelControllerObserver]()
    
    private let serializationQueue = DispatchQueue(label: "SerializationQueue", qos: .background)
    
    var drawings: [PKDrawing] {
        get { dataModel.drawings }
        set { dataModel.drawings = newValue }
    }
    
    
    init() {
        loadDataModel()
    }
    
    
    func updateDrawing(_ drawing: PKDrawing, at index: Int) {
        dataModel.drawings[index] = drawing
        saveDataModel()
    }
    
    
    private func didChange() {
        for observer in  self.observers {
            observer.dataModelChanged()
        }
    }
    
    private var saveURL: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths.first!
        return documentsDirectory.appendingPathComponent("Writting.data")
    }
    
    
    func saveDataModel() {
        let savingDataModel = dataModel
        let url = saveURL
        serializationQueue.async {
            do {
                let encoder = PropertyListEncoder()
                let data = try encoder.encode(savingDataModel)
                try data.write(to: url)
            } catch {
                os_log("write 데이터모델 저장 못함: %s", type: .error, error.localizedDescription)
            }
        }
    }
    
    private func loadDataModel() {
        let url = saveURL
        serializationQueue.async {
            let dataModel: DataModel
            
            if FileManager.default.fileExists(atPath: url.path) {
                do {
                    let decoder = PropertyListDecoder()
                    let data = try Data(contentsOf: url)
                    dataModel = try decoder.decode(DataModel.self, from: data)
                } catch {
                    os_log("write 데이터모델 없음: %s", type: .error, error.localizedDescription)
                    dataModel = self.loadDefaultDrawing()
                }
            } else {
                dataModel = self.loadDefaultDrawing()
            }
            
            DispatchQueue.main.async {
                self.setLoadedDataModel(dataModel)
            }
        }
    }
    
    
    
    private func loadDefaultDrawing() -> DataModel {
        var testDataModel = DataModel()
        for sampleDataName in DataModel.defaultDrawingNames {
            guard let data = NSDataAsset(name: sampleDataName)?.data else { continue }
            if let drawing = try? PKDrawing(data: data) {
                testDataModel.drawings.append(drawing)
            }
        
        }
        return testDataModel
    }
    
    
    
    private func setLoadedDataModel(_ dataModel: DataModel) {
        self.dataModel = dataModel
    }
    
    
    func newDrawing() {
        let newDrawing = PKDrawing()
        updateDrawing(newDrawing, at: dataModel.drawings.count - 1)
    }
}



