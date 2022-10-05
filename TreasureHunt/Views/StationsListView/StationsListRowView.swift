//
//  StationsListRowView.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 25.09.22.
//

import MapKit
import SwiftUI

struct StationsListRowView: View {
  let station: Station

  var body: some View {
    VStack(alignment: .leading, spacing: 5) {
      Text(station.name)
        .font(.headline)
        .fontWeight(.semibold)

      if !station.question.isEmpty {
        Text("**A:** *\(station.question)*")
          .foregroundColor(.secondary)
          .font(.caption)
      } else {
        Text("Keine Aufgabe für diese Station gestellt.")
          .italic()
          .foregroundColor(.secondary)
          .font(.caption)
      }
    }
    .padding(.vertical, 4)
  }
}

struct StationsListRowView_Previews: PreviewProvider {
  static let station = Station(clCoordinate: .init(latitude: 20, longitude: 20), triggerDistance: 30, name: "Random", question: "This could be a wonderful question!")

  static var previews: some View {
    StationsListRowView(station: station)
      .environmentObject(StationsStore())
      .environmentObject(LocationProvider())
      .padding()
      .previewLayout(.sizeThatFits)
  }
}
