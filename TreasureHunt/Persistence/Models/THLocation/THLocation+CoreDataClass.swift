//
//  THLocation+CoreDataClass.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 04.12.22.
//
//

import Foundation
import CoreData

@objc(THLocation)
public class THLocation: NSManagedObject {}

extension THLocation {
  class func exampleTHLocation(withTitle: String,
                               in context: NSManagedObjectContext = PersistenceController.shared.context) -> THLocation {
    let location = THLocation(context: context)
    location.id = UUID()
    location.title = withTitle
    return location
  }
}

