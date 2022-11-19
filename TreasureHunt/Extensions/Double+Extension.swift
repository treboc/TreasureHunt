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

  func asDistance() -> String {
    let distanceFormatter: LengthFormatter = {
      let formatter = LengthFormatter()
      formatter.unitStyle = .short
      formatter.numberFormatter.maximumFractionDigits = 0
      return formatter
    }()

    return distanceFormatter.string(fromMeters: self)
  }
}
