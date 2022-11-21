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
    let realm = try Realm()
    guard var huntToEdit = realm.object(ofType: Hunt.self, forPrimaryKey: hunt._id) else { return }

    do {
      try realm.write {
        huntToEdit = Hunt(value: ["name": name,
                                  "introduction": introduction,
                                  "outline": outline])
        huntToEdit.stations.append(objectsIn: stations)
        realm.create(Hunt.self, value: huntToEdit, update: .all)
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
