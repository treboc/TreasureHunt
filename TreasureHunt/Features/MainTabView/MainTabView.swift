//
//  MainTabView.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 26.09.22.
//

import SwiftUI

struct MainTabView: View {
  @Environment(\.theme.tintColor) private var tintColor
  
  var body: some View {
    TabView {
      HuntListView()
        .tabItem {
          Label(L10n.MainTabView.TabItem.huntList,
                systemImage: "signpost.right.and.left.circle")
        }

      LocationsListView()
        .tabItem {
          Label(L10n.MainTabView.TabItem.stationList,
                systemImage: "mappin.circle")
        }

      SettingsView()
        .tabItem {
          Label(L10n.MainTabView.TabItem.settings,
                systemImage: "gear.circle")
        }
    }
    .toolbarBackground(.visible, for: .tabBar)
    .tint(tintColor)
  }
}

struct MainTabView_Previews: PreviewProvider {
  static var previews: some View {
    MainTabView()
  }
}
