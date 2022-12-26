//
//  SoundType.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 10.10.22.
//

import Foundation

extension AudioPlayer {
  enum SoundType: String {
    case success, error

    var fileURL: URL {
      return Bundle.main.url(forResource: self.rawValue, withExtension: "wav")!
    }
  }
}
