//
//  THStationModelService.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 11.12.22.
//

import CoreData
import Foundation

struct THStationModelService {
  /// Creates and returns a new THStation object with a valid UUID.
  /// - Parameter context: The context the station should be initialized in.
  /// - Returns: A THStation object with valid UUID
  static func newStation(in context: NSManagedObjectContext) -> THStation {
    let station = THStation(context: context)
    station.id = UUID()
    return station
  }

  /// When a station is provided, you get back a copy of this object. When the station provided can not be found or no station is provided, a new Station is created in the child context.
  ///
  /// - Parameter station: THStation object to create a copy of
  /// - Returns: A THStation object to work on
  static func createStationToEdit(of station: THStation? = nil) -> THStation {
    let childContext = PersistenceController.shared.childContext

    if let station,
       let stationToEdit = try? childContext.existingObject(with: station.objectID) as? THStation {
      return stationToEdit
    } else {
      return newStation(in: childContext)
    }
  }
}
