//
//  THStation+CoreDataProperties.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 04.12.22.
//
//

import Foundation
import CoreData

extension THStation {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<THStation> {
    return NSFetchRequest<THStation>(entityName: "THStation")
  }

  @NSManaged public var id: UUID?
  @NSManaged public var index: Int64
  @NSManaged public var title: String?
  @NSManaged public var task: String?
  @NSManaged public var location: THLocation?
  @NSManaged public var hunt: THHunt?
}

extension THStation {
  public var unwrappedTitle: String {
    get { title ?? "" }
    set { title = newValue }
  }

  public var unwrappedTask: String {
    get { task ?? "" }
    set { task = newValue }
  }
}

extension THStation: Identifiable {}
