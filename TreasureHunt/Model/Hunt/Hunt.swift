//
//  Hunt.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 10.10.22.
//

import CoreLocation
import Foundation
import RealmSwift

final class Hunt: Object, ObjectKeyIdentifiable {
  @Persisted(primaryKey: true) var _id: ObjectId
  @Persisted var name: String = ""
  @Persisted var createdAt: Date = .now
  @Persisted var stations: List<Station>

  convenience init(name: String) {
    self.init()
    self.name = name
  }

  var centerLocation: CLLocationCoordinate2D {
    let centerLat = stations.map(\.latitude).reduce(0.0, +) / Double(stations.count)
    let centerLong = stations.map(\.longitude).reduce(0.0, +) / Double(stations.count)
    return CLLocationCoordinate2D(latitude: centerLat, longitude: centerLong)
  }
}

extension Hunt {
  static let hunt = Hunt(name: "Dummy Station")
}
