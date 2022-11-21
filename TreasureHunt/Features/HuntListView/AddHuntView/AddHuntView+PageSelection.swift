//
//  AddHuntView+PageSelection.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 20.11.22.
//

import Foundation

extension AddHuntView {
  enum PageSelection: Int {
    case name, intro, stations, outline

    func nextPage() -> PageSelection {
      if self == .name {
        return .intro
      } else if self == .intro {
        return .stations
      } else if self == .stations {
        return .outline
      } else {
        return self
      }
    }

    func prevPage() -> PageSelection {
      if self == .outline {
        return .stations
      } else if self == .stations {
        return .intro
      } else if self == .intro {
        return .name
      } else {
        return self
      }
    }
  }
}
