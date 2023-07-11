//
//  ColorManager.swift
//  WriteBible
//
//  Created by 이택성 on 2022/06/24.
//

/*
    UI 색상값을 위한 Color extension
 */


import SwiftUI

extension Color {
    
    static let titleBackground = Color(hex: "7882A4")
    static let titleTextColor = Color(hex: "FBF7F0")
    static let selectedColor = Color(hex: "CDC9C3")
    static let contentTextColor = Color(hex: "2B2B2B")
    static let chapterTitleColor = Color(hex: "C0A080")
    static let simpleTitleColor = Color(hex: "435560")
    
    
    init(hex: String) {
        let scanner = Scanner(string: hex)      //문자열 파서 역할하는 클래스
        _ = scanner.scanString("#")             // #문자 제거
            
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)              // 문자열을 Int64타입으로 변환해 rgb 변수에 저장, 변환이 안되면 0으로 반환
        
        let r = Double((rgb >> 16) & 0xFF) / 255.0          // 좌측 문자열 2개 추출
        let g = Double((rgb >> 8) & 0xFF) / 255.0          // 중간 문자열 2개 추출
        let b = Double((rgb >> 0) & 0xFF) / 255.0          // 좌측 문자열 2개 추출
        
        self.init(red: r, green: g, blue: b)
    }
        
}
