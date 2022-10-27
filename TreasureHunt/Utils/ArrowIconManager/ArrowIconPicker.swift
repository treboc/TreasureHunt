//
//  ArrowIconPicker.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 26.09.22.
//

import SwiftUI

struct ArrowIconPicker: View {
  @AppStorage("arrowIcon") private var arrowIcon: ArrowIcon = .locationNorthFill

  var body: some View {
    Picker(L10n.SettingsView.ArrowPicker.title, selection: $arrowIcon) {
      ForEach(ArrowIcon.allCases, id: \.self) { icon in
        Label(icon.name, systemImage: icon.systemImage)
          .labelStyle(.iconOnly)
      }
    }
    .pickerStyle(.menu)
    .accessibilityElement()
    .accessibilityLabel(Text("Pfeil, \(arrowIcon.name)"))
  }
}

extension ArrowIconPicker {
  enum ArrowIcon: String, CaseIterable {
    case arrow
    case triangleFill
    case triangleOutlined
    case arrowMerged
    case locationNorth
    case locationNorthFill

    var name: String {
      switch self {
      case .arrow:
        return L10n.SettingsView.ArrowPicker.arrow
      case .triangleFill:
        return L10n.SettingsView.ArrowPicker.triangleFill
      case .triangleOutlined:
        return L10n.SettingsView.ArrowPicker.triangleOutlined
      case .arrowMerged:
        return L10n.SettingsView.ArrowPicker.arrowMerged
      case .locationNorth:
        return L10n.SettingsView.ArrowPicker.locationNorth
      case .locationNorthFill:
        return L10n.SettingsView.ArrowPicker.locationNorthFill
      }
    }

    var systemImage: String {
      switch self {
      case .arrow:
        return "arrow.up"
      case .triangleFill:
        return "arrowtriangle.up.fill"
      case .triangleOutlined:
        return "arrowtriangle.up"
      case .arrowMerged:
        return "arrow.triangle.merge"
      case .locationNorth:
        return "location.north"
      case .locationNorthFill:
        return "location.north.fill"
      }
    }
  }
}
