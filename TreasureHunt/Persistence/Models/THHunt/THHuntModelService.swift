//
//  THHuntModelService.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 10.10.22.
//

import Foundation
import CoreData

struct THHuntModelService {
  static func createHunt(title: String,
                         hasIntroduction: Bool,
                         introduction: String? = nil,
                         hasOutline: Bool,
                         outline: String? = nil,
                         outlineLocation: THLocation? = nil,
                         stations: [THStation],
                         in context: NSManagedObjectContext = PersistenceController.shared.context) {
    let hunt = THHunt(context: context)
    hunt.id = .init()
    hunt.title = title
    hunt.hasIntroduction = hasIntroduction
    if hasIntroduction {
      hunt.introduction = introduction
    }
    hunt.hasOutline = hasOutline
    if hasOutline {
      hunt.outline = outline
      hunt.outlineLocation = outlineLocation
    }

    hunt.stations = NSSet(array: stations)

    try? PersistenceController.shared.context.save()
  }

  static func updateHunt(hunt: THHunt,
                         withStations stations: [THStation],
                         in context: NSManagedObjectContext = PersistenceController.shared.context) {
    guard let context = hunt.managedObjectContext else { return }

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
                         title: String,
                         hasIntroduction: Bool,
                         introduction: String? = nil,
                         hasOutline: Bool,
                         outline: String? = nil,
                         outlineLocation: THLocation? = nil,
                         stations: [THStation],
                         in context: NSManagedObjectContext = PersistenceController.shared.context) {
    hunt.id = .init()
    hunt.title = title
    hunt.hasIntroduction = hasIntroduction
    if hasIntroduction {
      hunt.introduction = introduction
    }
    hunt.hasOutline = hasOutline
    if hasOutline {
      hunt.outline = outline
      hunt.outlineLocation = outlineLocation
    }

    let stationsToRemove = NSSet(array: hunt.stationsArray.filter({ !stations.contains($0) }))
    hunt.removeFromStations(stationsToRemove)

    let stationsToAdd = NSSet(array: stations.filter { !hunt.stationsArray.contains($0) })
    hunt.addToStations(stationsToAdd)

    try? hunt.managedObjectContext?.save()
  }


  static func delete(_ hunt: THHunt) {
    PersistenceController.shared.context.delete(hunt)
    try? PersistenceController.shared.context.save()
  }
}
