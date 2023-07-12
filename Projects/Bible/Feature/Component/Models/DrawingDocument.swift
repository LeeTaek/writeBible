//
//  DrawingDocument.swift
//  WriteBible
//
//  Created by 이택성 on 2022/06/22.
//

import Foundation

struct DrawingDocument: Identifiable
{
    var id = UUID()
    var data: Data
    var title: String
}
