//
//  StationsListRowView.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 25.09.22.
//

import MapKit
import SwiftUI

struct StationsListRowView: View {
  @EnvironmentObject private var locationProvider: LocationProvider
  let id: Int
  let station: Station

  var distanceToStation: String {
    let distanceFormatter: MKDistanceFormatter = {
      let formatter = MKDistanceFormatter()
      formatter.unitStyle = MKDistanceFormatter.DistanceUnitStyle.default
      return formatter
    }()

    return distanceFormatter.string(fromDistance: locationProvider.distanceTo(station.location) ?? 0)
  }

  var body: some View {
    HStack(spacing: 10) { 
        Text(id, format: .number)
          .font(.system(.title2, design: .rounded))
          .monospacedDigit()
          .padding()
          .background(
            Circle()
              .strokeBorder(.tint, lineWidth: 3)
          )
          .padding(.horizontal, 3)

      VStack(alignment: .leading, spacing: 5) {
        Text(station.name)
          .font(.title3)
          .fontWeight(.semibold)

        if !station.question.isEmpty {
          Text("**Aufgabe:** *\(station.question)*")
            .foregroundColor(.secondary)
        } else {
          Text("Keine Aufgabe für diese Station gestellt.")
            .italic()
            .foregroundColor(.secondary)
        }

        Text("Von hier aus: \(distanceToStation)")
      }
    }
  }
}

struct StationsListRowView_Previews: PreviewProvider {
  static let station = Station(clCoordinate: .init(latitude: 20, longitude: 20), triggerDistance: 30, name: "Random", question: "This could be a wonderful question!")

  static var previews: some View {
    StationsListRowView(id: 0, station: station)
      .environmentObject(StationsStore())
      .environmentObject(LocationProvider())
      .padding()
      .previewLayout(.sizeThatFits)
  }
}
