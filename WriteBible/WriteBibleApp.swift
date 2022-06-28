//
//  WriteBibleApp.swift
//  WriteBible
//
//  Created by 이택성 on 2022/06/02.
//

import SwiftUI

@main
struct WriteBibleApp: App {
    
    let setting = SettingManager().getSetting()
    
    var body: some Scene {
        WindowGroup {
            ContentView(setting: setting)
        }
    }
}
