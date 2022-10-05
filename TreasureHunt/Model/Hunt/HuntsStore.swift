//
//  HuntsStore.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 03.10.22.
//

import Foundation

final class HuntsStore: ObservableObject {
  private static let fileURL: URL = FileManager.default.huntsStoreURL

  @Published var allHunts: [Hunt] = []

  init() {
    self.allHunts = loadHuntsFromDisk()
  }

  func loadHuntsFromDisk() -> [Hunt] {
    var allHunts: [Hunt] = []
    do {
      let data = try Data(contentsOf: Self.fileURL)
      allHunts = try JSONDecoder().decode([Hunt].self, from: data)
    } catch {
      allHunts = []
    }
    return allHunts
  }

  private func writeHuntsToDisk(_ hunts: [Hunt]) {
    do {
      let data = try JSONEncoder().encode(hunts)
      try data.write(to: Self.fileURL, options: .atomic)
    } catch {
      print("\(#file), \(#line): \(error)")
    }
  }

  func persist(_ hunt: Hunt, onCompletion: @escaping (() -> Void)) {
    allHunts.append(hunt)
    writeHuntsToDisk(allHunts)
    onCompletion()
  }
}
