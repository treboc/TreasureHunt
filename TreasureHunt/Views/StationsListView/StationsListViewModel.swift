//
//  StationsListViewModel.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 26.09.22.
//

import SwiftUI

final class StationsListViewModel: ObservableObject {
  @Published var chosenStations: [Station] = []
  @Published var huntIsStarted: Bool = false
  @Published var newStationSheetIsShown: Bool = false
  @Published var stationToEdit: Station? = nil

  func toggleStationChosenState(_ station: Station) {
    withAnimation {
      if let index = chosenStations.firstIndex(of: station) {
        chosenStations.remove(at: index)
      } else {
        chosenStations.append(station)
      }
    }
  }

  func positionOf(_ station: Station) -> Int? {
    if let index = chosenStations.firstIndex(of: station) {
      return index + 1
    } else {
      return nil
    }
  }

  func resetState() {
    chosenStations.removeAll()
  }

  func showNewStationSheet() {
    newStationSheetIsShown = true
  }
}
