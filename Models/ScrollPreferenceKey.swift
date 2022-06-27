//
//  ScrollPreferenceKey.swift
//  WriteBible
//
//  Created by 이택성 on 2022/06/27.
//

import SwiftUI

struct ScrollPreferenceKey: PreferenceKey {
    
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
