//
//  AppearancePicker.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 26.09.22.
//

import SwiftUI

struct AppearancePicker: View {
 @EnvironmentObject var appearanceManager: AppearanceManager
 @ObservedObject var themeManager = ThemeManager.shared

 var body: some View {
  Picker(L10n.SettingsView.AppearancePicker.title, selection: $appearanceManager.appearance) {
   ForEach(AppearanceManager.Appearance.allCases, id: \.self) {
    Text($0.title)
   }
  }
  .pickerStyle(.menu)
  .accessibilityElement()
  .accessibilityLabel(Text("\(L10n.SettingsView.AppearancePicker.title), \(appearanceManager.appearance.title)"))
  .rebuildOnChange(of: themeManager.tintColor)
 }
}
