//
//  HuntListViewModel.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 03.10.22.
//

import Foundation

final class HuntListViewModel: ObservableObject {
  let huntsStore = HuntsStore()
  @Published var allHunts: [Hunt] = []
  @Published var newHuntViewIsShown: Bool = false

  init() {
    allHunts = huntsStore.loadHuntsFromDisk()
  }

  func updateHunts() {
    allHunts = huntsStore.loadHuntsFromDisk()
  }

  func showNewHuntView() {
    newHuntViewIsShown = true
  }
}
