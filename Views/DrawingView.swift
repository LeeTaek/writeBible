//
//  DrawingView.swift
//  WriteBible
//
//  Created by 이택성 on 2022/06/20.
//

import SwiftUI
import SimultaneouslyScrollView
import Introspect

struct DrawingView: View {
    @Environment(\.managedObjectContext) var viewContext

    @State var id:UUID?
    @State var data:Data?
    @State var title:String?
    
    var body: some View {
        VStack{
            DrawingCanvasView(data: data ?? Data(), id: id ?? UUID())
                .environment(\.managedObjectContext, viewContext)
            
            
        }
    }
}

struct DrawingView_Previews: PreviewProvider {
    static var previews: some View {
        DrawingView()
    }
}
