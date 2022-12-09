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
      HuntListView()
        .tabItem {
          Label(L10n.MainTabView.TabItem.huntList,
                systemImage: "shippingbox")
        }

      LocationsListView()
        .tabItem {
          Label(L10n.MainTabView.TabItem.stationList,
                systemImage: "dot.circle.and.hand.point.up.left.fill")
        }

      SettingsView()
        .tabItem {
          Label(L10n.MainTabView.TabItem.settings,
                systemImage: "gear")
        }
    }
    .toolbarBackground(.visible, for: .tabBar)
  }
}

struct MainTabView_Previews: PreviewProvider {
  static var previews: some View {
    MainTabView()
  }
}
