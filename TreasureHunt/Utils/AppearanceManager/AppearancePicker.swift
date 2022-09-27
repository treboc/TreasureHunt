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
    HStack {
      Text("Farbschema")
      Spacer()
      Menu {
        Picker("Wähle ein Theme", selection: $appearanceManager.appearance) {
          ForEach(AppearanceManager.Appearance.allCases, id: \.self) {
            Text($0.title)
          }
        }
      } label: {
        Text(appearanceManager.appearance.title)
      }
    }
  }
}
