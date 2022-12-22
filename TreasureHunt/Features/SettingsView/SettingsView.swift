//
//  SettingsView.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 26.09.22.
//

import SwiftUI

struct SettingsView: View {
  @AppStorage(UserDefaults.SettingsKeys.idleDimmingDisabled) private var idleDimmingDisabled: Bool = true
  @AppStorage(UserDefaults.SettingsKeys.hapticsActivated) private var hapticsActivated: Bool = true
  @AppStorage(UserDefaults.SettingsKeys.soundsActivated) private var soundsActivated: Bool = true

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

        Section("About") {
          reviewLink
          NavigationLink("About") {
            AboutView()
          }
          NavigationLink(L10n.SettingsView.LegalNoticeView.navTitle) {
            LegalNoticeView()
          }
        }
      }
      .scrollContentBackground(.hidden)
      .gradientBackground()
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

extension SettingsView {
  private var reviewLink: some View {
    Link(destination: Constants.Links.reviewURL) {
      HStack {
        Text("Rate This App \(Image(systemName: "heart.fill"))")
        Spacer()
        Image(systemName: "arrow.up.right")
      }
    }
  }
}
