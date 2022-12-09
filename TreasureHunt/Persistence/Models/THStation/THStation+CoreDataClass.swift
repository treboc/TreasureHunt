//
//  THStation+CoreDataClass.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 04.12.22.
//
//

import Foundation
import CoreData

@objc(THStation)
public class THStation: NSManagedObject {
  public var isCompleted: Bool = false
}
