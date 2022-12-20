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
  enum HuntState: Equatable {
    case showIntroduction
    case findStation(station: THStation)
    case findOutline(outlineLocation: THLocation)
    case showOutline
    case finished
  }
}

extension HuntManager {
  var currentStationNumber: Int {
    guard
      let currentStation,
      let currentStationIndex = hunt.stationsArray.firstIndex(of: currentStation)
    else { return 0 }
    return currentStationIndex + 1
  }

  var isLastStation: Bool {
    guard let currentStation,
          let stationIndex = hunt.stationsArray.firstIndex(of: currentStation) else { return false }
    return stationIndex + 1 == hunt.stationsArray.count
  }

  var isNearCurrentStation: Bool {
    guard let location = currentStation?.location else { return false }
    return distanceToCurrentStation <= location.triggerDistance
  }

  private var currentStationsIndex: Int? {
    guard let currentStation else { return nil }
    return hunt.stationsArray.firstIndex(of: currentStation)
  }
}

final class HuntManager: ObservableObject {
  private var cancellables = Set<AnyCancellable>()
  let audioPlayer = AudioPlayer()

  @ObservedObject var locationProvider: LocationProvider

  @Published var hunt: THHunt
  @Published var currentStation: THStation? = nil
  @Published var outlineLocation: THLocation? = nil

  @Published private(set) var angleToCurrentStation: Double = 0
  @Published private(set) var distanceToCurrentStation: Double = 0

  @Published private(set) var huntState: HuntState = .finished


  init(locationProvider: LocationProvider = LocationProvider(),
       _ hunt: THHunt) {
    self.locationProvider = locationProvider
    self.hunt = hunt
    initialSetup()
  }

  private func initialSetup() {
    setFirstStation()
    setupPublishers()

    if hunt.hasIntroduction {
      huntState = .showIntroduction
    } else if let currentStation {
      huntState = .findStation(station: currentStation)
    }
  }

  private func setFirstStation() {
    if let firstStation = hunt.stationsArray.first {
      _currentStation = Published(initialValue: firstStation)
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

    $currentStation
      .map(\.?.location)
      .sink(receiveValue: changeLocation)
      .store(in: &cancellables)
  }

  private func changeLocation(_ location: THLocation?) {
    guard let location else { return }
    locationProvider.updateCurrentLocation(to: location)
  }

  private func onDistanceUpdate(_ distance: CLLocationDistance) {
    guard let currentStation,
              distance > 0
    else { return }

    self.distanceToCurrentStation = distance
    HapticManager.shared.triggerFeedback(on: distance)

    if isNearCurrentStation && !currentStation.isCompleted {
      audioPlayer.enteredStation()
      showQuestion()
    }
  }

  private func showQuestion() {
    guard let currentStation,
          !currentStation.isCompleted
    else { return }
    if !currentStation.unwrappedTask.isEmpty {
      huntState = .showIntroduction
    }
  }

  private func setNextStation() {
    guard
      let currentIndex = currentStationsIndex,
      currentIndex < hunt.stationsArray.count,
      let nextStation = hunt.stationsArray[safe: currentIndex + 1]
    else { return }

    self.currentStation = nextStation
    huntState = .findStation(station: nextStation)
  }

  func nextStationButtonTapped() {
    currentStation?.isCompleted = true
    audioPlayer.leftStation()

    if isLastStation && hunt.hasOutline {
      changeLocation(hunt.outlineLocation)
      outlineLocation = hunt.outlineLocation
    } else {
      setNextStation()
    }
  }

  func readIntroduction() {
    if let currentStation {
      withAnimation {
        huntState = .findStation(station: currentStation)
      }
    }
  }
}
