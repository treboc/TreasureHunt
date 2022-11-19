//
//  StationModelService.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 10.10.22.
//

import RealmSwift
import CoreLocation

struct StationModelService {
  static func add(_ station: THLocation) throws {
    do {
      let realm = try Realm()
      try realm.write {
        realm.add(station)
      }
    }
  }

  static func toggleFavorite(_ station: THLocation) {
    guard let station = station.thaw() else { return }

    do {
      let realm = try Realm()
      try realm.write {
        station.isFavorite.toggle()
      }
    } catch {
      print(error.localizedDescription)
    }
  }

  static func update(_ station: THLocation,
                     with coordinate: CLLocationCoordinate2D,
                     name: String,
                     triggerDistance: Double,
                     isFavorite: Bool) throws {
    guard let station = station.thaw() else { return }

    do {
      let realm = try Realm()
      try realm.write {
        station.longitude = coordinate.longitude
        station.latitude = coordinate.latitude
        station.name = name
        station.triggerDistance = triggerDistance
        station.isFavorite = isFavorite
      }
    } catch {
      throw error
    }
  }
}
