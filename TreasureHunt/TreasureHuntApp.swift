//  Created by Dominik Hauser on 08.09.22.
//  
//

import CoreLocation
import SwiftUI

@main
struct TreasureHuntApp: App {
  @StateObject private var appearanceManager = AppearanceManager()
  @StateObject private var themeManager = ThemeManager()
  @StateObject private var locationProvider = LocationProvider()

  @AppStorage(UserDefaults.SettingsKeys.locationAuthViewIsShown)
  private var locationOnboardingIsShown: Bool = false

  var body: some Scene {
    WindowGroup {
      MainTabView()
        .onAppear {
          locationProvider.checkLocationAuthorization(locationOnboardingIsShown: &locationOnboardingIsShown)
          appearanceManager.setAppearance()
          registerUserDefaults()
        }
        .sheet(isPresented: $locationOnboardingIsShown, content: LocationAuthorizationOnboardingView.init)
        .environment(\.managedObjectContext, PersistenceController.shared.context)
        .environmentObject(appearanceManager)
        .environmentObject(themeManager)
        .environmentObject(locationProvider)
        .tint(themeManager.tintColor)
    }
  }

  private func registerUserDefaults() {
    UserDefaults.standard.register(defaults: [
      "_UIConstraintBasedLayoutLogUnsatisfiable": false,
      UserDefaults.SettingsKeys.hapticsActivated: true,
      UserDefaults.SettingsKeys.soundsActivated: true,
      UserDefaults.SettingsKeys.idleDimmingDisabled: true
    ])
  }
}
