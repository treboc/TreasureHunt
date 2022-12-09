//
//  THLocation+CoreDataProperties.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 04.12.22.
//
//

import CoreData
import CoreLocation

extension THLocation {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<THLocation> {
    return NSFetchRequest<THLocation>(entityName: "THLocation")
  }
  
  @NSManaged public var id: UUID?
  @NSManaged public var title: String?
  @NSManaged public var latitude: Double
  @NSManaged public var longitude: Double
  @NSManaged public var triggerDistance: Double
  @NSManaged public var isFavourite: Bool

  var coordinate: CLLocationCoordinate2D {
    return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
  }

  var location: CLLocation {
    return CLLocation(latitude: latitude, longitude: longitude)
  }
}

extension THLocation {
  public var unwrappedTitle: String {
    get { title ?? "No Title" }
    set { title = newValue }
  }
}

extension THLocation : Identifiable {
  
}
