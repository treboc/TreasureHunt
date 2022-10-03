//
//  Double+Extension.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 03.10.22.
//

import Foundation

extension Double {
  func roundedToFive() -> Double {
    5 * (self / 5).rounded()
  }
}
