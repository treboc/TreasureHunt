//
//  StationModelService.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 10.10.22.
//

import RealmSwift
import CoreLocation

struct StationModelService {
  static func add(_ station: Station) throws {
    do {
      let realm = try Realm()
      try realm.write {
        realm.add(station)
      }
    }
  }

  static func update(_ station: Station, with coordinate: CLLocationCoordinate2D, name: String, triggerDistance: Double, question: String) throws {
    guard let station = station.thaw() else { return }

    do {
      let realm = try Realm()
      try realm.write {
        station.longitude = coordinate.longitude
        station.latitude = coordinate.latitude
        station.triggerDistance = triggerDistance
        station.name = name
        station.question = question
      }
    } catch {
      throw error
    }
  }
}
