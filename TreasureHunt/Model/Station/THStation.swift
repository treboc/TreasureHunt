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
  @Persisted var task: String?
  @Persisted var location: THLocation?

  var isCompleted: Bool = false

  convenience init(name: String, task: String? = nil, location: THLocation) {
    self.init()
    self.name = name
    self.task = task
    self.location = location
  }
}

extension THStation {
  static let station = THStation(name: "DummyStation", location: .location)

  static let stations: [THStation] = .init(repeating: .station, count: 5)
}
