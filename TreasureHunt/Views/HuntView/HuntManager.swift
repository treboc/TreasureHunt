//
//  HuntManager.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 25.09.22.
//

import Combine
import SwiftUI
import MapKit

final class HuntManager: ObservableObject {
  private var cancellables = Set<AnyCancellable>()
  var locationManager = LocationProvider()

  @Published var region: MKCoordinateRegion = .init()
  @Published var hunt: Hunt
  @Published var currentStation: Station?
  @Published var nextStation: Station?
  @Published var angleToCurrentStation: Double = 0
  @Published var distanceToCurrentStation: Double = 0
  @Published var questionSheetIsShown: Bool = false
  @Published var stations: [Station] = []
  
  var isNearCurrentStation: Bool {
    return distanceToCurrentStation <= currentStation?.triggerDistance ?? 0
  }

  var currentStationIsLastStation: Bool {
    if let index = currentStationsIndex() {
      if stations[safe: index + 1] != nil {
        return false
      }
    }
    return true
  }

  var currentStationNumber: Int? {
      guard let currentStation = currentStation,
            let currentStationIndex = stations.firstIndex(of: currentStation)
      else { return nil }
      return currentStationIndex + 1
  }

  init(_ hunt: Hunt) {
    _hunt = Published(initialValue: hunt)
    stations = StationsStore.loadHuntStations(hunt: hunt)
    if let firstStation = stations.first {
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

    if distance <= currentStation.triggerDistance {
      showQuestion()
    }
  }

  private func showQuestion() {
    if currentStation?.question.isEmpty == false {
      questionSheetIsShown = true
    }
  }

  func nextStationButtonTapped() {
    setCurrentToNextStation()
  }

  private func setCurrentToNextStation() {
    guard
      let station = currentStation,
      let currentIndex = stations.firstIndex(of: station)
    else { return }

    if let nextStation = stations[safe: currentIndex + 1] {
      self.currentStation = nextStation
      locationManager.distance = locationManager.distanceTo(nextStation.location) ?? 0
    }
  }

  func setNextStation() {
    guard
      let station = currentStation,
      let currentIndex = stations.firstIndex(of: station)
    else { return }

    if let nextStation = stations[safe: currentIndex + 1] {
      self.nextStation = nextStation
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

  private func currentStationsIndex() -> Int? {
    guard let currentStation else { return nil }
    return stations.firstIndex(of: currentStation)
  }
}
