//
//  HuntModelService.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 10.10.22.
//

import Foundation
import RealmSwift

struct HuntModelService {
  static func add(_ hunt: Hunt, with stations: [Station]) {
    do {
      let realm = try Realm()
      try realm.write {
        let thawedStations = stations.compactMap { $0.thaw() }
        hunt.stations.append(objectsIn: thawedStations)
        realm.add(hunt)
      }
    } catch {
      print(error.localizedDescription)
    }
  }

  static func update(_ hunt: Hunt, with name: String, and stations: [Station]) throws {
    let realm = try Realm()
    guard let huntToEdit = realm.object(ofType: Hunt.self, forPrimaryKey: hunt._id) else { return }

    do {
      try realm.write {
        huntToEdit.name = name
        let thawedStations = stations.compactMap { $0.thaw() }
        huntToEdit.stations.removeAll()
        huntToEdit.stations.append(objectsIn: thawedStations)
      }
    } catch {
      print(error.localizedDescription)
    }
  }

  static func delete(at index: Int) {
    do {
      let realm = try Realm()
      let allHunts = realm.objects(Hunt.self)
      try realm.write {
        realm.delete(allHunts[index])
      }
    } catch {
      print(error)
    }
  }
}
