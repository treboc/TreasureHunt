//
//  SettingsView.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 26.09.22.
//

import SwiftUI

struct SettingsView: View {
  var body: some View {
    NavigationView {
      Form {
        Section {
          AppearancePicker()
          ArrowIconPicker()
        }
      }
      .navigationTitle("Settings")
      .roundedNavigationTitle()
    }
  }
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView()
  }
}



