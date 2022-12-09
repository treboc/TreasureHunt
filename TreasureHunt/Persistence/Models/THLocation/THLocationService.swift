//
//  THLocationService.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 10.10.22.
//

import CoreLocation
import CoreData

struct THLocationService {
  static let context = PersistenceController.shared.context

  static func addLocation(title: String,
                          latitude: Double,
                          longitude: Double,
                          triggerDistance: Double,
                          in context: NSManagedObjectContext = context) {
    let location = THLocation(context: context)
    location.id = UUID()
    location.title = title
    location.latitude = latitude
    location.longitude = longitude
    location.triggerDistance = triggerDistance

    PersistenceController.shared.save()
  }

  static func updateLocation(thLocation: THLocation,
                             title: String,
                             latitude: Double,
                             longitude: Double,
                             triggerDistance: Double,
                             in context: NSManagedObjectContext = context) {
    thLocation.title = title
    thLocation.latitude = latitude
    thLocation.longitude = longitude
    thLocation.triggerDistance = triggerDistance

    PersistenceController.shared.save()
  }

  static func toggleFavourite(_ thLocation: THLocation,
                              in context: NSManagedObjectContext = context) {
    thLocation.isFavourite.toggle()
    try? context.save()
  }

  static func deleteLocation(_ thLocation: THLocation,
                             in context: NSManagedObjectContext = context) {
    context.delete(thLocation)
    try? context.save()
  }
}
