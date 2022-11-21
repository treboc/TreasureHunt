//
//  Hunt.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 10.10.22.
//

import CoreLocation
import RealmSwift

final class Hunt: Object, ObjectKeyIdentifiable {
  @Persisted(primaryKey: true) var _id: ObjectId
  @Persisted var name: String = ""
  @Persisted var createdAt: Date = .now
  @Persisted var introduction: String?
  @Persisted var outline: String?
  @Persisted var outlineLocation: THLocation?
  @Persisted var stations: List<THStation>

  convenience init(name: String) {
    self.init()
    self.name = name
  }

  var centerLocation: CLLocationCoordinate2D {
    let centerLat = stations.compactMap(\.location?.latitude).reduce(0.0, +) / Double(stations.count)
    let centerLong = stations.compactMap(\.location?.longitude).reduce(0.0, +) / Double(stations.count)
    return CLLocationCoordinate2D(latitude: centerLat, longitude: centerLong)
  }
}

extension Hunt {
  static let hunt = Hunt(name: "Dummy Station")
}
