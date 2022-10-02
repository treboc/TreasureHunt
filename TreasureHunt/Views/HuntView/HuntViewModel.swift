//
//  HuntViewModel.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 02.10.22.
//

import SwiftUI

final class HuntViewModel: ObservableObject {
  @AppStorage(SettingsKeys.idleDimmingDisabled) var idleDimmingDisabled: Bool = false

  @Published var warningRead: Bool = false
  @Published var endSessionAlertIsShown: Bool = false
  @Published var mapIsShown: Bool = false

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

