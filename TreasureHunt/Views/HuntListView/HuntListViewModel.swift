//
//  HuntListViewModel.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 03.10.22.
//

import Foundation

final class HuntListViewModel: ObservableObject {
  @Published var newHuntViewIsShown: Bool = false

  func showNewHuntView() {
    newHuntViewIsShown = true
  }
}
