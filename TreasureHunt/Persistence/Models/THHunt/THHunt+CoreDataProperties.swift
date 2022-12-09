//
//  THHunt+CoreDataProperties.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 04.12.22.
//
//

import CoreData
import CoreLocation

extension THHunt {

  @nonobjc public class func fetchRequest() -> NSFetchRequest<THHunt> {
    return NSFetchRequest<THHunt>(entityName: "THHunt")
  }

  @NSManaged public var title: String?
  @NSManaged public var id: UUID?
  @NSManaged public var createdAt: Date?
  @NSManaged public var hasIntroduction: Bool
  @NSManaged public var hasOutline: Bool
  @NSManaged public var outline: String?
  @NSManaged public var introduction: String?
  @NSManaged public var outlineLocation: THLocation?
  @NSManaged public var stations: NSSet?

  var centerLocation: CLLocationCoordinate2D {
    let centerLat = stationsArray.compactMap(\.location?.latitude).reduce(0.0, +) / Double(stationsArray.count)
    let centerLong = stationsArray.compactMap(\.location?.longitude).reduce(0.0, +) / Double(stationsArray.count)
    return CLLocationCoordinate2D(latitude: centerLat, longitude: centerLong)
  }
}

extension THHunt {
  public var stationsArray: [THStation] {
    let stationsSet = stations as? Set<THStation> ?? []

    return stationsSet.sorted {
      $0.index < $1.index
    }
  }
}

extension THHunt {
  public var unwrappedTitle: String {
    get { title ?? "" }
    set { title = newValue }
  }

  public var unwrappedCreatedAt: Date {
    get { createdAt ?? .now }
    set { createdAt = newValue }
  }

  public var unwrappedIntroduction: String {
    get { introduction ?? "" }
    set { introduction = newValue }
  }

  public var unwrappedOutline: String {
    get { outline ?? "" }
    set { outline = newValue }
  }
}

// MARK: Generated accessors for stations
extension THHunt {

  @objc(addStationsObject:)
  @NSManaged public func addToStations(_ value: THStation)

  @objc(removeStationsObject:)
  @NSManaged public func removeFromStations(_ value: THStation)

  @objc(addStations:)
  @NSManaged public func addToStations(_ values: NSSet)

  @objc(removeStations:)
  @NSManaged public func removeFromStations(_ values: NSSet)

}

extension THHunt : Identifiable {

}
