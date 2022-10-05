//
//  StationsListViewModel.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 26.09.22.
//

import SwiftUI

final class StationsListViewModel: ObservableObject {
  @Published var newStationSheetIsShown: Bool = false
  @Published var stationToEdit: Station? = nil

  func showNewStationSheet() {
    newStationSheetIsShown = true
  }
}
