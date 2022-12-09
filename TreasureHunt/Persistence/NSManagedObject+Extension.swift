//
//  NSManagedObject+Extension.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 10.12.22.
//

import CoreData
import Foundation

extension NSManagedObject {
  func childObject<T: NSManagedObject>() throws -> T? {
    guard let parentContext = self.managedObjectContext else { fatalError() }

    let childContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    childContext.parent = parentContext

    return try childContext.existingObject(with: self.objectID) as? T
  }
}
