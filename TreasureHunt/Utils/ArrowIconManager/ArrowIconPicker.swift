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
    VStack(alignment: .leading) {
      Text("Wähle einen Pfeil")
      Picker("Pfeil", selection: $arrowIcon) {
        ForEach(ArrowIcon.allCases, id: \.self) { icon in
          Image(systemName: icon.systemImageName)
        }
      }
      .pickerStyle(.segmented)
    }
  }
}

extension ArrowIconPicker {
  enum ArrowIcon: String, CaseIterable {
    case arrow
    case triangleFilled
    case triangleOutlined
    case arrowMerged

    var systemImageName: String {
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
