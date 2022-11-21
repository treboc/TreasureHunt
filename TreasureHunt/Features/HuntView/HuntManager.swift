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
  let audioPlayer = AudioPlayer()

  @ObservedObject var locationProvider: LocationProvider
  @ObservedRealmObject var hunt: Hunt

  @Published var currentStation: THStation? = nil
  @Published var angleToCurrentStation: Double = 0
  @Published var distanceToCurrentStation: Double = 0
  @Published var questionSheetIsShown: Bool = false
  @Published var isNearCurrentStation: Bool = false

  var currentStationIsLastStation: Bool {
    guard let currentStationIndex = getCurrentStationsIndex() else { return false}
    return currentStationIndex + 1 == hunt.stations.count
  }

  var currentStationNumber: Int {
    guard
      let currentStation,
      let currentStationIndex = hunt.stations.firstIndex(of: currentStation)
    else { return 0 }
    return currentStationIndex + 1
  }

  init(locationProvider: LocationProvider = LocationProvider(),
       _ hunt: Hunt) {
    self.locationProvider = locationProvider
    self.hunt = hunt
    if let firstStation = hunt.stations.first {
      _currentStation = Published(initialValue: firstStation)
      setupPublishers()
    }
  }

  private func setupPublishers() {
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
        guard let location = self?.currentStation?.location else { return false }
        return $0 <= location.triggerDistance
      }
      .assign(to: \.isNearCurrentStation, on: self)
      .store(in: &cancellables)
  }

  private func onStationChanged(_ station: THStation?) {
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
    if !(currentStation?.isCompleted ?? false) {
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
      let currentStation,
      let currentIndex = hunt.stations.firstIndex(of: currentStation)
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
