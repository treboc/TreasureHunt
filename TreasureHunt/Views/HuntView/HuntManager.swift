//
//  HuntManager.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 25.09.22.
//

import AVFoundation
import Combine
import MapKit
import RealmSwift
import SwiftUI

final class HuntManager: ObservableObject {
  private var cancellables = Set<AnyCancellable>()
  var locationProvider = LocationProvider()
  let audioPlayer = AudioPlayer()

  @ObservedRealmObject var hunt: Hunt
  @Published var currentStation: Station?
  @Published var angleToCurrentStation: Double = 0
  @Published var distanceToCurrentStation: Double = 0
  @Published var questionSheetIsShown: Bool = false
  @Published var isNearCurrentStation: Bool = false

  var currentStationIsLastStation: Bool {
    guard let currentStationIndex = getCurrentStationsIndex() else { return false}
    return currentStationIndex + 1 == hunt.stations.count
  }

  var currentStationNumber: Int {
    guard let currentStation = currentStation,
          let currentStationIndex = hunt.stations.firstIndex(of: currentStation)
    else { return 0 }
    return currentStationIndex + 1
  }

  init(_ hunt: Hunt) {
    _hunt = ObservedRealmObject(wrappedValue: hunt)
    if let firstStation = hunt.stations.first {
      currentStation = firstStation
    }

    locationProvider
      .$angle
      .assign(to: &$angleToCurrentStation)

    locationProvider
      .$distance
      .map { $0.roundedToFive() }
      .removeDuplicates()
      .sink(receiveValue: onDistanceUpdate)
      .store(in: &cancellables)

    $currentStation
      .sink(receiveValue: onStationChanged)
      .store(in: &cancellables)

    $distanceToCurrentStation
      .map { [weak self] in
        guard let station = self?.currentStation else { return false }
        return $0 <= station.triggerDistance
      }
      .assign(to: \.isNearCurrentStation, on: self)
      .store(in: &cancellables)
  }

  private func onStationChanged(_ station: Station?) {
    guard let station else { return }
    locationProvider.didChange(station)
  }

  private func onDistanceUpdate(_ distance: CLLocationDistance) {
    guard distance > 0 else { return }
    self.distanceToCurrentStation = distance
    HapticManager.shared.triggerFeedback(on: distance)

    if isNearCurrentStation {
      audioPlayer.enteredStation()
      showQuestion()
    }
  }

  private func showQuestion() {
    guard let currentStation else { return }
    if currentStation.question.isEmpty == false && !currentStation.isCompleted {
      questionSheetIsShown = true
    }
  }

  func nextStationButtonTapped() {
    currentStation?.isCompleted = true
    audioPlayer.leftStation()
    setCurrentToNextStation()
  }

  private func setCurrentToNextStation() {
    guard
      let station = currentStation,
      let currentIndex = hunt.stations.firstIndex(of: station)
    else { return }

    if currentIndex + 1 < hunt.stations.count {
      let nextStation = hunt.stations[currentIndex + 1]
      self.currentStation = nextStation
    }
  }

  private func getCurrentStationsIndex() -> Int? {
    guard let currentStation else { return nil }
    return hunt.stations.firstIndex(of: currentStation)
  }
}
