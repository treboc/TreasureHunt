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
  @Published var stations: [Station] = []
  @Published var currentStation: Station?
  @Published var nextStation: Station?
  @Published var angleToCurrentStation: Double = 0
  @Published var distanceToCurrentStation: Double = 0
  @Published var questionSheetIsShown: Bool = false

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

  init(_ stations: [Station]) {
    self.stations = stations
    if let firstStation = stations.first {
      currentStation = firstStation
      setNextStation()
    }

    locationManager
      .$distance
      .assign(to: &$distanceToCurrentStation)

    locationManager
      .$angle
      .assign(to: &$angleToCurrentStation)

    locationManager
      .$distance
      .sink(receiveValue: onDistanceUpdate)
      .store(in: &cancellables)

    $currentStation
      .sink { [weak self] station in
        guard let station = station else { return }
        let location: CLLocation = .init(latitude: station.coordinate.latitude,
                                         longitude: station.coordinate.longitude)
        self?.locationManager.currentStationLocation = location
        self?.locationManager.triggerDistance = station.triggerDistance
        self?.locationManager.start()
      }
      .store(in: &cancellables)
  }

  private func onDistanceUpdate(_ distance: CLLocationDistance) {
    guard let currentStation else { return }

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
    currentStation?.reachedStation()
    setCurrentToNextStation()
  }

  private func setCurrentToNextStation() {
    guard
      let station = currentStation,
      let currentIndex = stations.firstIndex(of: station)
    else { return }

    if let nextStation = stations[safe: currentIndex + 1] {
      self.currentStation = nextStation
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
