//
//  UserDefaults+Extension.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 03.10.22.
//

import Foundation

extension UserDefaults {
  enum SettingsKeys {
    static let hapticsActivated = "hapticsActivated"
    static let soundsActivated = "soundsActivated"
    static let selectedAppearance = "selectedAppearance"
    static let idleDimmingDisabled = "idleDimmingDisabled"
    static let locationAuthViewIsShown = "locationAuthViewIsShown"
  }

  enum TooltipKeys {
    static let editLocations = "editLocations"
  }
}
