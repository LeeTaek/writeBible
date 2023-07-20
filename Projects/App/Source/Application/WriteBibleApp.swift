//
//  WriteBibleApp.swX
//
//  Created by 이택성 on 2022/06/02.
//

import SwiftUI
import Bible

@main
struct WriteBibleApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}

