//
//  Array+Extension.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 26.09.22.
//

import Foundation

extension Array {
  subscript(safe index: Int) -> Element? {
    guard index >= 0, index < endIndex else {
      return nil
    }

    return self[index]
  }
}
