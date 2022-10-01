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
  private var locationManager = LocationProvider()

  @AppStorage(SettingsKeys.idleDimmingDisabled) var idleDimmingDisabled: Bool = false
  @Published var region: MKCoordinateRegion = .init()
  @Published var stations: [Station] = []
  @Published var currentStation: Station?
  @Published var angle: Double = 0
  @Published var distance: Double = 0
  @Published var questionSheetIsShown: Bool = false
  @Published var isNearCurrentStation: Bool = false

  init(_ stations: [Station]) {
    self.stations = stations
    if let firstStation = stations.first {
      currentStation = firstStation
    }

    locationManager
      .$reachedStation
      .sink { [weak self] reachedStation in
        if reachedStation {
          self?.showQuestion()
        }
      }
      .store(in: &cancellables)

    locationManager
      .$distance
      .assign(to: &$distance)

    locationManager
      .$angle
      .assign(to: &$angle)

    locationManager
      .$distance
      .map { [weak self] in
        return $0 < self?.currentStation?.triggerDistance ?? 20
      }
      .assign(to: &$isNearCurrentStation)

    $currentStation
      .sink { [weak self] station in
        guard let station = station else { return }
        let location: CLLocation = .init(latitude: station.coordinate.latitude,
                                         longitude: station.coordinate.longitude)
        self?.locationManager.nextLocation = location
        self?.locationManager.triggerDistance = station.triggerDistance
        self?.locationManager.start()
      }
      .store(in: &cancellables)
  }

  private func showQuestion() {
    if currentStation?.question.isEmpty == false {
      questionSheetIsShown = true
    }
  }

  func setNextStation() {
    guard
      let station = currentStation,
      let currentIndex = stations.firstIndex(of: station)
    else { return }

    if let nextStation = stations[safe: currentIndex + 1] {
      currentStation = nextStation
      isNearCurrentStation = false
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
}
