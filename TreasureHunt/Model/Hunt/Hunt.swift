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
  var stations: [Station]
  var createdAt: Date = .now

  var centerLocation: CLLocationCoordinate2D {
    let count = Double(stations.count)
    let lat = stations.map(\.location.coordinate.latitude).reduce(0.0, +) / count
    let lon = stations.map(\.location.coordinate.longitude).reduce(0.0, +) / count
    return CLLocationCoordinate2D(latitude: lat, longitude: lon)
  }
}
