//
//  MainViewModel.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 25.09.22.
//

import SwiftUI

final class MainViewModel: ObservableObject {
  @Published var mapIsHidden: Bool = true
  @Published var sheetIsShowing = false
  @Published var sheetState: Sheet? = nil {
    willSet { sheetIsShowing = newValue != nil }
  }
}

// MARK: - SheetHandling
extension MainViewModel {
  enum Sheet {
    case newStation
    case stationsList
    case question(Station)
  }

  @ViewBuilder
  func sheetContent() -> some View {
    switch sheetState {
    case .newStation:
      AddNewStationView()
    case .stationsList:
      StationsListView()
    case .question(let station):
      QuestionView(station: station)
    case .none:
      EmptyView()
    }
  }
}
