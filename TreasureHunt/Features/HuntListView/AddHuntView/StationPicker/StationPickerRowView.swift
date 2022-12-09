//
//  StationPickerRowView.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 04.10.22.
//

import SwiftUI

struct StationPickerRowView: View {
  enum StationPickerRowType {
    case chosen
    case available
  }

  let index: Int?
  let location: THLocation
  let rowType: StationPickerRowType

  @ViewBuilder
  private var positionImage: some View {
    if let index {
     Image(systemName: "\(index + 1).circle.fill")
        .font(.title2)
        .foregroundStyle(Color.accentColor.gradient)
    }
  }

  var body: some View {
    HStack {
      if rowType == .chosen {
        positionImage
      }
      Text(location.unwrappedTitle)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .contentShape(Rectangle())
  }
}

struct StationPickerRowView_Previews: PreviewProvider {
    static var previews: some View {
      StationPickerRowView(index: 1,
                           location: .exampleTHLocation(withTitle: "Testing",
                                                        in: PersistenceController.preview.context),
                           rowType: .available)
    }
}
