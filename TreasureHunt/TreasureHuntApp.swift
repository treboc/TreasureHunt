//  Created by Dominik Hauser on 08.09.22.
//  
//

import SwiftUI

@main
struct TreasureHuntApp: App {
  @StateObject private var locationProvider = LocationProvider()
    
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(locationProvider)
    }
  }
}
