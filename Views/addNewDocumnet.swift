////
////  addNewDocumnet.swift
////  WriteBible
////
////  Created by 이택성 on 2022/06/22.
////
//
//import SwiftUI
//
//struct AddNewDocument: View {
//
//    @ObservedObject var manager: DrawingManager
//    @State private var documentName : String = ""
//    @Binding var addShown: Bool
//    
//    var body: some View {
//        VStack {
//            
//            Text("Enter document name:")
//            
//            TextField("Enter document name here...", text: $documentName, onCommit: {
//               save(fileName: documentName)
//            })
//            .textFieldStyle(RoundedBorderTextFieldStyle())
//            
//            Button("Create") {
//                save(fileName: documentName)
//            }
//        }.padding()
//    }
//    
//    
//    
//    
//    private func save(fileName: String){
//        manager.addData(doc: DrawingDocument(data: Data(), title: fileName))
//        addShown.toggle()
//    }
//    
//}
////