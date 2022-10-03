//
//  ArrowIconPicker.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 26.09.22.
//

import SwiftUI

struct ArrowIconPicker: View {
  @AppStorage("arrowIcon") private var arrowIcon: ArrowIcon = .arrow

  var body: some View {
    Picker("Pfeil", selection: $arrowIcon) {
      ForEach(ArrowIcon.allCases, id: \.self) { icon in
        Label(icon.name, systemImage: icon.systemImage)
          .labelStyle(.iconOnly)
      }
    }
    .pickerStyle(.menu)
  }
}

extension ArrowIconPicker {
  enum ArrowIcon: String, CaseIterable {
    case arrow
    case triangleFilled
    case triangleOutlined
    case arrowMerged

    var name: String {
      switch self {
      case .arrow:
        return "Pfeil"
      case .triangleFilled:
        return "Dreieck (gefüllt)"
      case .triangleOutlined:
        return "Dreieck"
      case .arrowMerged:
        return "Pfeil, verbunden"
      }
    }

    var systemImage: String {
      switch self {
      case .arrow:
        return "arrow.up"
      case .triangleFilled:
        return "arrowtriangle.up.fill"
      case .triangleOutlined:
        return "arrowtriangle.up"
      case .arrowMerged:
        return "arrow.triangle.merge"
      }
    }
  }
}
