//
//  HuntModelService.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 10.10.22.
//

import Foundation
import RealmSwift

struct HuntModelService {
  static func createHunt(name: String, introduction: String? = nil, stations: [THStation], outline: String? = nil) {
    let hunt = Hunt(value: ["name": name,
                            "introduction": introduction,
                            "outline": outline])
    hunt.stations.append(objectsIn: stations)
    do {
      let realm = try Realm()
      try realm.write {
        realm.create(Hunt.self, value: hunt, update: .modified)
      }
    } catch {
      print(error.localizedDescription)
    }
  }

  static func updateHunt(name: String, introduction: String? = nil, stations: [THStation], outline: String? = nil) {
    let hunt = Hunt(value: ["name": name,
                            "introduction": introduction,
                            "outline": outline])
    hunt.stations.append(objectsIn: stations)
    do {
      let realm = try Realm()
      try realm.write {
        realm.create(Hunt.self, value: hunt, update: .all)
      }
    } catch {
      print(error.localizedDescription)
    }
  }

  static func update(_ hunt: Hunt, name: String, introduction: String? = nil, stations: [THStation], outline: String? = nil) throws {
    do {
      let realm = try Realm()
      if let hunt = realm.object(ofType: Hunt.self, forPrimaryKey: hunt._id) {
        try realm.write {
          hunt.stations.removeAll()
          for station in stations {
            if let station = realm.object(ofType: THStation.self, forPrimaryKey: station._id) {
              hunt.stations.append(station)
            } else {
              let newStation = realm.create(THStation.self, value: station, update: .modified)
              hunt.stations.append(newStation)
            }
          }
          hunt.name = name
          hunt.introduction = introduction
          hunt.outline = outline
        }
      }
    } catch {
      print(error.localizedDescription)
    }
  }

  static func delete(with id: ObjectId) {
    do {
      let realm = try Realm()
      if let huntToDelete = realm.objects(Hunt.self).first(where: { $0._id == id }) {
        try realm.write {
          realm.delete(huntToDelete.stations)
          realm.delete(huntToDelete)
        }
      }
    } catch {
      print(error)
    }
  }
}
