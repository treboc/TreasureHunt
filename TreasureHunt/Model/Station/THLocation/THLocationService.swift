//
//  THLocationService.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 10.10.22.
//

import RealmSwift
import CoreLocation

struct THLocationService {
  static func add(_ location: THLocation) throws {
    do {
      let realm = try Realm()
      try realm.write {
        realm.add(location)
      }
    }
  }

  static func toggleFavorite(_ location: THLocation) {
    guard let location = location.thaw() else { return }

    do {
      let realm = try Realm()
      try realm.write {
        location.isFavorite.toggle()
      }
    } catch {
      print(error.localizedDescription)
    }
  }

  static func update(_ location: THLocation,
                     with coordinate: CLLocationCoordinate2D,
                     name: String,
                     triggerDistance: Double,
                     isFavorite: Bool) throws {
    guard let location = location.thaw() else { return }

    do {
      let realm = try Realm()
      try realm.write {
        location.longitude = coordinate.longitude
        location.latitude = coordinate.latitude
        location.name = name
        location.triggerDistance = triggerDistance
        location.isFavorite = isFavorite
      }
    } catch {
      throw error
    }
  }
}
