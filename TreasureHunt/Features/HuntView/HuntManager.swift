//
//  HuntManager.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 25.09.22.
//

import AVFoundation
import Combine
import MapKit
import SwiftUI

extension HuntManager {
  enum HuntState {
    case introduction
    case findStation(THStation)
    case outline
    case finished
  }
}

final class HuntManager: ObservableObject {
  private var cancellables = Set<AnyCancellable>()
  let audioPlayer = AudioPlayer()

  @ObservedObject var locationProvider: LocationProvider

  @Published var hunt: THHunt
  @Published var currentStation: THStation? = nil
  @Published private(set) var huntState: HuntState = .finished

  @Published private(set) var angleToCurrentStation: Double = 0
  @Published private(set) var distanceToCurrentStation: Double = 0
  @Published private(set) var isNearCurrentStation: Bool = false
  @Published var questionSheetIsShown: Bool = false
  @Published var introductionSheetIsShown: Bool = false


  var currentStationNumber: Int {
    guard
      let currentStation,
      let currentStationIndex = hunt.stationsArray.firstIndex(of: currentStation)
    else { return 0 }
    return currentStationIndex + 1
  }

  init(locationProvider: LocationProvider = LocationProvider(),
       _ hunt: THHunt) {
    self.locationProvider = locationProvider
    self.hunt = hunt
    setupHunt()
  }

  private func setupHunt() {
    if hunt.hasIntroduction {
      huntState = .introduction
    } else {
      setFirstStation()
    }

    setupPublishers()
  }

  func setFirstStation() {
    if let firstStation = hunt.stationsArray.first {
      _currentStation = Published(initialValue: firstStation)
      huntState = .findStation(firstStation)
    }
  }

  private func setupPublishers() {
    locationProvider
      .$angle
      .assign(to: \.angleToCurrentStation, on: self)
      .store(in: &cancellables)

    locationProvider
      .$distance
      .map { $0.roundedToFive() }
      .removeDuplicates()
      .sink(receiveValue: onDistanceUpdate)
      .store(in: &cancellables)

    $huntState
      .sink { state in
        switch state {
        case .introduction:
          self.introductionSheetIsShown = true
        case .findStation(let station):
          self.onStationChanged(station)
        case .outline:
         break
        case .finished:
          break
        }
      }
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
    locationProvider.updateCurrentStation(to: station)
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
      let currentIndex = hunt.stationsArray.firstIndex(of: currentStation)
    else { return }

    if currentIndex + 1 < hunt.stationsArray.count {
      let nextStation = hunt.stationsArray[currentIndex + 1]
      self.currentStation = nextStation
    }
  }

  private func currentStationsIndex() -> Int? {
    guard let currentStation else { return nil }
    return hunt.stationsArray.firstIndex(of: currentStation)
  }

  func isLastStation() -> Bool {
    let endIndex = hunt.stationsArray.endIndex
    guard let currentStation,
          let stationIndex = hunt.stationsArray.firstIndex(of: currentStation) else { return false }
    return endIndex == stationIndex
  }
}
