//  Created by Dominik Hauser on 08.09.22.
//  
//

import SwiftUI

@main
struct TreasureHuntApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(LocationProvider())
    }
  }
}
