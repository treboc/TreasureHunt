//  Created by Dominik Hauser on 08.09.22.
//  
//

import SwiftUI

@main
struct TreasureHuntApp: App {
  @StateObject private var appearanceManager = AppearanceManager()
  @StateObject private var stationsStore = StationsStore()

  var body: some Scene {
    WindowGroup {
      MainTabView()
        .environmentObject(stationsStore)
        .environmentObject(appearanceManager)
        .onAppear {
          appearanceManager.setAppearance()
          UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        }
        .tint(.primaryAccentColor)
    }
  }
}
