//
//  MainTabView.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 26.09.22.
//

import SwiftUI

struct MainTabView: View {
  var body: some View {
    TabView {
      StationsListView()
        .tabItem {
          makeTabItem(.stationsList)
        }

      SettingsView()
        .tabItem {
          makeTabItem(.settings)
        }
    }
  }
}

struct MainTabView_Previews: PreviewProvider {
  static var previews: some View {
    MainTabView()
  }
}

extension MainTabView {
  enum TabItem {
    case settings
    case stationsList
  }

  private func makeTabItem(_ tabItem: TabItem) -> Label<Text, Image> {
    switch tabItem {
    case .settings:
      return Label("Einstellungen", systemImage: "gear")
    case .stationsList:
      return Label("Stationen", systemImage: "dot.circle.and.hand.point.up.left.fill")
    }
  }
}
