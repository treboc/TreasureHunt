//
//  StationPickerRowView.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 04.10.22.
//

import SwiftUI

struct StationPickerRowView: View {
  let index: Int
  let station: Station

  private var positionImage: some View {
    return Image(systemName: "\(index + 1).circle.fill")
      .font(.title2)
      .foregroundStyle(Color.accentColor.gradient)
  }

  var body: some View {
    HStack(spacing: 16) {
      positionImage
      Text(station.name)
    }
    .contentShape(Rectangle())
  }
}

struct StationPickerRowView_Previews: PreviewProvider {
    static var previews: some View {
      StationPickerRowView(index: 1, station: Station(clCoordinate: .init(), name: "Testing"))
    }
}
