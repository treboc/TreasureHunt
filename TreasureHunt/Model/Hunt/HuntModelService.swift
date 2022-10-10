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

  static func delete(_ atOffset: IndexSet) {
    guard let firstIndex = atOffset.first else { return }
    do {
      let realm = try Realm()
      let allHunts = realm.objects(Hunt.self)
      try realm.write {
        realm.delete(allHunts[firstIndex])
      }
    } catch {
      print(error)
    }
  }
}
