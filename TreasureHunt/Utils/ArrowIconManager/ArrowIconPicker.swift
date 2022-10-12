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
    Picker("Pfeil", selection: $arrowIcon) {
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
        return "Pfeil"
      case .triangleFill:
        return "Dreieck (gefüllt)"
      case .triangleOutlined:
        return "Dreieck"
      case .arrowMerged:
        return "Pfeil (verbunden)"
      case .locationNorth:
        return "Position"
      case .locationNorthFill:
        return "Position (gefüllt)"
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
