//
//  HuntViewModel.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 25.09.22.
//

import SwiftUI

final class HuntViewModel: ObservableObject {
  @Published var mapIsHidden: Bool = true
  @Published var questionSheetIsShown: Bool = false
}

final class HuntManager: ObservableObject {
  @Published var currentStation: Station?
  @Published var stations: [Station] = []

  init(_ stations: [Station]) {
    self.stations = stations
    if let firstStation = stations.first {
      currentStation = firstStation
    }
  }

  func setNextStation() {
    guard
      let station = currentStation,
      let currentIndex = stations.firstIndex(of: station)
    else { return }

    if let nextStation = stations[safe: currentIndex + 1] {
      currentStation = nextStation
    }
  }

  func setPreviousStation() {
    guard
      let station = currentStation,
      let currentIndex = stations.firstIndex(of: station)
    else { return }

    if let prevStation = stations[safe: currentIndex - 1] {
      currentStation = prevStation
    }
  }
}
