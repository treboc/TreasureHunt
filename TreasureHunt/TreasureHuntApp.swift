//  Created by Dominik Hauser on 08.09.22.
//  
//

import SwiftUI

@main
struct TreasureHuntApp: App {
  @StateObject private var locationProvider = LocationProvider()
  @StateObject private var stationsStore = StationsStore()

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(locationProvider)
        .environmentObject(stationsStore)
        .onAppear {
          UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        }
    }
  }
}
