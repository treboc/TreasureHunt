//  Created by Dominik Hauser on 08.09.22.
//  
//

import CoreLocation
import SwiftUI

@main
struct TreasureHuntApp: App {
  @StateObject private var appearanceManager = AppearanceManager()
  @StateObject private var locationProvider = LocationProvider()
  @AppStorage(UserDefaultsKeys.locationAuthViewIsShown) private var locationOnboardingIsShown: Bool = false
  @Environment(\.scenePhase) private var phase

  var body: some Scene {
    WindowGroup {
      MainTabView()
        .onAppear(perform: checkAuthorization)
        .task {
          appearanceManager.setAppearance()
          registerUserDefaults()
        }
        .sheet(isPresented: $locationOnboardingIsShown, content: LocationAuthorizationOnboardingView.init)
        .environmentObject(appearanceManager)
        .environmentObject(locationProvider)
        .tint(.primaryAccentColor)
    }
  }

  private func registerUserDefaults() {
    UserDefaults.standard.register(defaults: [
      "_UIConstraintBasedLayoutLogUnsatisfiable": false,
      UserDefaultsKeys.hapticsActivated: true,
      UserDefaultsKeys.soundsActivated: true,
      UserDefaultsKeys.idleDimmingDisabled: true
    ])
  }

  private func checkAuthorization() {
    switch locationProvider.locationManager.authorizationStatus {
    case .restricted, .notDetermined, .denied:
      locationOnboardingIsShown = true
    case .authorizedAlways, .authorizedWhenInUse:
      locationOnboardingIsShown = false
    @unknown default:
      return
    }
  }
}
