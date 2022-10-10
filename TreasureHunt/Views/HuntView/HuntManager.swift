//
//  HuntManager.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 25.09.22.
//

import Combine
import MapKit
import RealmSwift
import SwiftUI

final class HuntManager: ObservableObject {
  private var cancellables = Set<AnyCancellable>()
  var locationManager = LocationProvider()

  @ObservedRealmObject var hunt: Hunt
  @Published var currentStation: Station?
  @Published var nextStation: Station?
  @Published var angleToCurrentStation: Double = 0
  @Published var distanceToCurrentStation: Double = 0
  @Published var questionSheetIsShown: Bool = false

  var isNearCurrentStation: Bool {
    return distanceToCurrentStation <= currentStation?.triggerDistance ?? 0
  }

  var currentStationIsLastStation: Bool {
    guard let currentStationIndex = currentStationsIndex() else { return false}
    return currentStationIndex + 1 == hunt.stations.count
  }

  var currentStationNumber: Int? {
      guard let currentStation = currentStation,
            let currentStationIndex = hunt.stations.firstIndex(of: currentStation)
      else { return nil }
      return currentStationIndex + 1
  }

  init(_ hunt: Hunt) {
    _hunt = ObservedRealmObject(wrappedValue: hunt)
    if let firstStation = hunt.stations.first {
      currentStation = firstStation
      setNextStation()
    }

    locationManager
      .$angle
      .assign(to: &$angleToCurrentStation)

    locationManager
      .$distance
      .map { $0.roundedToFive() }
      .removeDuplicates()
      .sink(receiveValue: onDistanceUpdate)
      .store(in: &cancellables)

    $currentStation
      .sink { [weak self] station in
        guard let station = station else { return }
        self?.locationManager.currentStationLocation = station.location
        self?.locationManager.triggerDistance = station.triggerDistance
        self?.locationManager.start()
      }
      .store(in: &cancellables)
  }

  private func onDistanceUpdate(_ distance: CLLocationDistance) {
    guard
      let currentStation,
      distance > 0
    else { return }
    self.distanceToCurrentStation = distance
    HapticManager.shared.triggerFeedback(on: distance)
    if isNearCurrentStation {
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
      locationManager.distance = locationManager.distanceTo(nextStation.location) ?? 0
    }
  }

  func setNextStation() {
    guard
      let station = currentStation,
      let currentIndex = hunt.stations.firstIndex(of: station)
    else { return }

    if currentIndex + 1 < hunt.stations.count {
      let nextStation = hunt.stations[currentIndex + 1]
      self.nextStation = nextStation
    }
  }

  func setPreviousStation() {
    guard
      let station = currentStation,
      let currentIndex = hunt.stations.firstIndex(of: station)
    else { return }

    if currentIndex - 1 > 0 {
      let prevStation = hunt.stations[currentIndex - 1]
      currentStation = prevStation
    }
  }

  private func currentStationsIndex() -> Int? {
    guard let currentStation else { return nil }
    return hunt.stations.firstIndex(of: currentStation)
  }
}
