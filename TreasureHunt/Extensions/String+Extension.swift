//
//  String+Extension.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 16.10.22.
//

import Foundation

extension Double {
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
