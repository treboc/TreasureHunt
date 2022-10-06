//
//  Hunt.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 03.10.22.
//

import Foundation
import CoreLocation

struct Hunt: Codable, Identifiable {
  var id: UUID = .init()
  let name: String
  var stations: [Station.ID]
  var createdAt: Date = .now

  var centerLocation: CLLocationCoordinate2D {
    let stationsStore = StationsStore()
    let huntStations = stationsStore.allStations.filter { station in
      stations.contains(station.id)
    }
    let lat = huntStations.map(\.location.coordinate.latitude).reduce(0.0, +) / Double(huntStations.count)
    let lon = huntStations.map(\.location.coordinate.longitude).reduce(0.0, +) / Double(huntStations.count)
    return CLLocationCoordinate2D(latitude: lat, longitude: lon)
  }
}
