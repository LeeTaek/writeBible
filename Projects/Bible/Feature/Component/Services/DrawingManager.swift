//
//  DrawingManager.swift
//  WriteBible
//
//  Created by 이택성 on 2022/06/22.
//

import SwiftUI

class  DrawingManager: ObservableObject {
    
    @Published var docs : [DrawingDocument]
    
    init() {
        docs = RealmManager.shared.getAllData()
    }
    
    func update(data: Data, for title: String){
        
        if let index = self.docs.firstIndex(where: {$0.title == title}){
            self.docs[index].data = data
            RealmManager.shared.updateData(data: self.docs[index])

        }
    }
    
    func getData(for title: String ) -> Data {
        if let doc = self.docs.first(where: {$0.title == title}){
            return doc.data
        }
        return Data()
    }
    
    func addData(doc:DrawingDocument){
        docs.append(doc)
        RealmManager.shared.addData(document: doc)
    }
    
    func delete(for indexSet: IndexSet){
        for index in indexSet {
            RealmManager.shared.deleteData(data: docs[index])
            docs.remove(at: index)
        }
    }
}
