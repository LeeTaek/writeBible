//
//  ContentView.swift
//  WriteBible
//
//  Created by 이택성 on 2022/06/02.
//

import SwiftUI

import ComposableArchitecture
import RealmSwift

struct MainFeature: ReducerProtocol {
  struct State: Equatable {
    var bible: Bible = .init(title: .genesis)
    var showingSettingSheet: Bool = false
    var showingTitle: Bool = false
  }
  
  enum Action: Equatable {
    case moveNextChapter
    case moveBeforeChapter
    case showTitle
    case hideTitle
    case showSettingSheet
    case hideSettingSheet
    case showDrawView
    case hideDrawView
  }
  
  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    default :
      return .none
    }
  }
  
}


public struct ContentView: View {
    
    @State var bibleTitle: BibleTitle = .genesis
    @State var chapterNum: Int = 1
    @State private var showingSheet = false
    @State private var showTitle = false
    @ObservedResults(SettingManager.self, configuration: Realm.Configuration(schemaVersion: 1)) var settingValue        //셋팅값을 위한 RealmDB

        
  public init() {
    self.bibleTitle = .genesis
    self.chapterNum = 1
    self.showingSheet = false
    self.showTitle = false
  }
    
    public var body: some View {
        let setting = settingValue.first ?? SettingManager()      

        return BibleView(bibleTitle: $bibleTitle, chapterNum: $chapterNum, showTitle: $showTitle, settingValue: setting)
            .overlay() {
                TitleView(bibleTitle: $bibleTitle, chapter: $chapterNum, showTitleSheet: $showingSheet, settingValue: setting)
                        .opacity(showTitle ? 0 : 1)
            }.onAppear(){
                
                let saved = RecentWritingManager().getSetting()
              Log.debug(saved)
                chapterNum = Int(String(saved.components(separatedBy: "txt").last!))!
                bibleTitle = BibleTitle(rawValue: saved.components(separatedBy: "txt").first! + "txt")!
                
            }

    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

