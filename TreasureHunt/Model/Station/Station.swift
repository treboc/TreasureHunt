//
//  RealmStation.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 10.10.22.
//

import CoreLocation
import RealmSwift

final class Station: Object, ObjectKeyIdentifiable {
  @Persisted(primaryKey: true) var _id: ObjectId
  @Persisted var longitude: Double = 0
  @Persisted var latitude: Double = 0
  @Persisted var triggerDistance: Double = 5
  @Persisted var name: String = ""
  @Persisted var question: String = ""
  @Persisted var isFavorite: Bool = false
  var isCompleted: Bool = false

  convenience init(coordinate: CLLocationCoordinate2D, triggerDistance: Double, name: String, question: String) {
    self.init()
    self.longitude = coordinate.longitude
    self.latitude = coordinate.latitude
    self.triggerDistance = triggerDistance
    self.name = name
    self.question = question
  }

  var coordinate: CLLocationCoordinate2D {
    return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
  }

  var location: CLLocation {
    return CLLocation(latitude: latitude, longitude: longitude)
  }
}

extension Station {
  static let station = Station(coordinate: .init(latitude: 10, longitude: 50), triggerDistance: 50, name: "Dummy Station", question: "No questions at all!")
}
