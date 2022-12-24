//
//  AddHuntView+PageSelection.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 20.11.22.
//

import Foundation

extension AddHuntView {
  enum PageSelection: Int {
    case name, intro, stations, outro

    func nextPage() -> PageSelection {
      if self == .name {
        return .intro
      } else if self == .intro {
        return .stations
      } else if self == .stations {
        return .outro
      } else {
        return self
      }
    }

    func prevPage() -> PageSelection {
      if self == .outro {
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
