//
//  AppearancePicker.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 26.09.22.
//

import SwiftUI

struct AppearancePicker: View {
  @EnvironmentObject var appearanceManager: AppearanceManager

  var body: some View {
    Picker("Farbschema", selection: $appearanceManager.appearance) {
      ForEach(AppearanceManager.Appearance.allCases, id: \.self) {
        Text($0.title)
      }
    }
    .pickerStyle(.menu)
    .accessibilityElement()
    .accessibilityLabel(Text("Farbschema, \(appearanceManager.appearance.title)"))
  }
}
