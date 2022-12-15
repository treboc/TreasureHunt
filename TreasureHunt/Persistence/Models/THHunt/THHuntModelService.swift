//
//  THHuntModelService.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 10.10.22.
//

import Foundation
import CoreData

struct THHuntModelService {
  static func updateHunt(hunt: THHunt,
                         withStations stations: [THStation]) {
    guard let context = hunt.managedObjectContext else { return }

    if hunt.createdAt == nil {
      hunt.createdAt = .now
    }

    // remove all stations
    hunt.stations = NSSet()

    // add all stations
    for (i, station) in stations.enumerated() {
      station.index = Int64(i)
      hunt.addToStations(station)
    }

    if context.hasChanges {
      try? PersistenceController.shared.persist(hunt)
    }
  }

  static func updateHunt(hunt: THHunt,
                         in context: NSManagedObjectContext = PersistenceController.shared.context) {
    guard let context = hunt.managedObjectContext else { return }

    if context.hasChanges {
      try? PersistenceController.shared.persist(hunt)
    }
  }


  static func delete(_ hunt: THHunt) {
    PersistenceController.shared.context.delete(hunt)
    try? PersistenceController.shared.context.save()
  }
}
