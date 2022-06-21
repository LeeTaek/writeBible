//
//  WriteBibleApp.swift
//  WriteBible
//
//  Created by 이택성 on 2022/06/02.
//

import SwiftUI

@main
struct WriteBibleApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
