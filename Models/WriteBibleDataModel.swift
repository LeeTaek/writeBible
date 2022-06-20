//
//  WriteBibleDataModel.swift
//  WriteBible
//
//  Created by 이택성 on 2022/06/14.
//

import Foundation
import PencilKit
import RealmSwift
import os

struct DataModel: Codable  {
    static let defaultDrawingNames: [String] = ["test writting"]
    
    var drawings: [PKDrawing] = []
}

protocol DataModelControllerObserver{
    func dataModelChanged()
}


class WriteBibleDataModel: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var bibleTitle: String
    @Persisted var chapter: Int
    @Persisted var drawingData: Data
    
    var dataModel = DataModel()
    var observers = [DataModelControllerObserver]()
    
    private let serializationQueue = DispatchQueue(label: "SerializationQueue", qos: .background)
    
    var drawings: [PKDrawing] {
        get { dataModel.drawings }
        set { dataModel.drawings = newValue }
    }
  
    
//    
//    override init() {
//        print(#fileID, #function, #line, "")
//        print("경로 : \(Realm.Configuration.defaultConfiguration.fileURL!)")
//        
//        super.init()
//        loadDataModel()
//    }
//    
//    
    convenience init(drawingData: Data) {
        print(#fileID, #function, #line, "")
        print("경로 : \(Realm.Configuration.defaultConfiguration.fileURL!)")

        //        self.bibleTitle = title
        //        self.chapter = chapter
        
        self.init()
        self.drawingData = drawingData
    }
    
 

    
    func updateDrawing(_ drawing: PKDrawing, at index: Int) {
        dataModel.drawings[index] = drawing
        saveDataModel()
    }
    
    
    
    func saveDataModel() {
        print("경로 : \(Realm.Configuration.defaultConfiguration.fileURL!)")

        let realm = try! Realm()
        let savingDataModel = dataModel

//        serializationQueue.async {
            do {
                let encoder = PropertyListEncoder()
                self.drawingData = try encoder.encode(savingDataModel)
                
                let saveObject = WriteBibleDataModel(drawingData: self.drawingData)
                
                try realm.write {
                    realm.add(saveObject)
                }
                
            } catch {
                os_log("write 데이터모델 저장 못함: %s", type: .error, error.localizedDescription)
            }
//        }
    }
    
    
    
     func loadDataModel() {
        print("경로 : \(Realm.Configuration.defaultConfiguration.fileURL!)")

        let realm = try! Realm()
        
//        serializationQueue.async {
            let dataModel: DataModel
            let loadRealmObject = realm.objects(WriteBibleDataModel.self)
//                .where {
//                $0.bibleTitle == self.bibleTitle && $0.chapter == self.chapter
//            }
            
            print(#fileID, #function, #line, "\(loadRealmObject.count)")

            if !loadRealmObject.isEmpty {
                do {
                    let decoder = PropertyListDecoder()
                    let data = loadRealmObject.first!.drawingData
                    dataModel = try decoder.decode(DataModel.self, from: data)
                } catch {
                    os_log("write 데이터모델 없음: %s", type: .error, error.localizedDescription)
                    dataModel = self.loadDefaultDrawing()
                }
            } else {
                print(#fileID, #function, #line, "해당장 데이터 오브젝트 없음")
                dataModel = self.loadDefaultDrawing()
            }
            
            DispatchQueue.main.async {
                self.setLoadedDataModel(dataModel)
            }
//        }
    }
    
    
    
    private func loadDefaultDrawing() -> DataModel {
        var testDataModel = DataModel()
        for sampleDataName in DataModel.defaultDrawingNames {
            guard let data = NSDataAsset(name: sampleDataName)?.data else { continue }
            if let drawing = try? PKDrawing(data: data) {
                print(#fileID, #function, #line, "")
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
        dataModel.drawings.append(newDrawing)
        updateDrawing(newDrawing, at: dataModel.drawings.count - 1)
    }
}

