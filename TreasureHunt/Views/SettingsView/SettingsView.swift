//
//  SettingsView.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 26.09.22.
//

import SwiftUI

struct SettingsView: View {
  @AppStorage(SettingsKeys.idleDimmingDisabled) private var idleDimmingDisabled: Bool = true

  var body: some View {
    NavigationView {
      Form {
        Section {
          AppearancePicker()
          ArrowIconPicker()
          idleDimmingToggle
        }
      }
      .navigationTitle("Einstellungen")
      .roundedNavigationTitle()
    }
  }
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView()
  }
}

extension SettingsView {
  private var idleDimmingToggle: some View {
    Toggle("Abschaltung des Displays während einer Suche verhindern", isOn: $idleDimmingDisabled)
  }
}
