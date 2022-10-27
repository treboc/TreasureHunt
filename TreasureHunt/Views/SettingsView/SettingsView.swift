//
//  SettingsView.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 26.09.22.
//

import SwiftUI

struct SettingsView: View {
  @AppStorage(UserDefaultsKeys.idleDimmingDisabled) private var idleDimmingDisabled: Bool = true
  @AppStorage(UserDefaultsKeys.hapticsActivated) private var hapticsActivated: Bool = true
  @AppStorage(UserDefaultsKeys.soundsActivated) private var soundsActivated: Bool = true

  var body: some View {
    NavigationView {
      Form {
        Section {
          AppearancePicker()
          ArrowIconPicker()
          soundsToggle
          hapticsToggle
          idleDimmingToggle
        } footer: {
          Text(L10n.SettingsView.idleDimmingToggleDescription)
            .font(.caption)
            .italic()
        }
      }
      .navigationTitle(L10n.SettingsView.navTitle)
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
  private var hapticsToggle: some View {
    Toggle(L10n.SettingsView.hapticsToggleTitle, isOn: $hapticsActivated)
  }

  private var soundsToggle: some View {
    Toggle(L10n.SettingsView.soundToggleTitle, isOn: $soundsActivated)
  }

  private var idleDimmingToggle: some View {
    Toggle(L10n.SettingsView.idleDimmingToggleTitle, isOn: $idleDimmingDisabled)
  }
}
