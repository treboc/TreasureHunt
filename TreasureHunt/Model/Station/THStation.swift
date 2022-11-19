//
//  THStation.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 06.11.22.
//

import CoreLocation
import RealmSwift

final class THStation: Object, ObjectKeyIdentifiable {
  @Persisted(primaryKey: true) var _id: ObjectId
  @Persisted var name: String = ""
  @Persisted var location: THLocation?

  var isCompleted: Bool = false

  convenience init(name: String) {
    self.init()
    self.name = name
  }
}

extension THStation {
  static let station = THStation(name: "DummyStation")
}
