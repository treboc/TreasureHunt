//
//  HuntViewModel.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 02.10.22.
//

import MapKit
import SwiftUI

final class HuntViewModel: ObservableObject {
  @AppStorage(UserDefaults.SettingsKeys.idleDimmingDisabled) var idleDimmingDisabled: Bool = false

  @Published var warningRead: Bool = false
  @Published var endSessionAlertIsShown: Bool = false
  @Published var mapIsShown: Bool = false
  @Published var region = MKCoordinateRegion(center: .init(), latitudinalMeters: 100, longitudinalMeters: 100)

  func showMap() {
    mapIsShown = true
  }

  func hideMap() {
    mapIsShown = false
  }

  func applyIdleDimmingSetting() {
    UIApplication.shared.isIdleTimerDisabled = idleDimmingDisabled
  }

  func disableIdleDimming() {
    UIApplication.shared.isIdleTimerDisabled = false
  }

  func endHuntButtonTapped() {
    endSessionAlertIsShown = true
  }
}

