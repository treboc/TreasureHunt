//
//  CLLocationDistance+Extension.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 12.12.22.
//

import CoreLocation

extension CLLocationDistance {
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
