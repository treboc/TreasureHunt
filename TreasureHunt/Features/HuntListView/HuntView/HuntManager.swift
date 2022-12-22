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
  enum HuntError: LocalizedError {
    case noStations
  }

  enum HuntState: Equatable {
    case showIntroduction(introduction: String)
    case findStation(station: THStation)
    case showTask(task: String)
    case findOutline(outlineLocation: THLocation)
    case showOutline(outline: String)
    case finished
  }

  var currentStationNumber: Int {
    guard
      case .findStation(let station) = huntState,
      let currentStationIndex = hunt.stationsArray.firstIndex(of: station)
    else { return 0 }
    return currentStationIndex + 1
  }

  var isLastStation: Bool {
    guard case .findStation(let station) = huntState,
          let stationIndex = hunt.stationsArray.firstIndex(of: station) else { return false }
    return stationIndex + 1 == hunt.stationsArray.count
  }

  var isNearCurrentLocation: Bool {
    var location: THLocation? = nil
    if case .findStation(let station) = huntState {
      location = station.location
    } else if case .findOutline(let outline) = huntState {
      location = outline
    }

    return distanceToCurrentLocation <= location?.triggerDistance ?? 25
  }

  private var currentStationsIndex: Int? {
    guard case .findStation(let station) = huntState else { return nil }
    return hunt.stationsArray.firstIndex(of: station)
  }
}

final class HuntManager: ObservableObject {
  private var cancellables = Set<AnyCancellable>()
  let audioPlayer = AudioPlayer()

  @ObservedObject var locationProvider: LocationProvider

  @Published private(set) var hunt: THHunt
  @Published var error: HuntError? = nil

  @Published private(set) var angleToCurrentStation: Double = 0
  @Published private(set) var distanceToCurrentLocation: Double = 0
  @Published private(set) var huntState: HuntState = .finished

  init(locationProvider: LocationProvider = LocationProvider(),
       _ hunt: THHunt) {
    self.locationProvider = locationProvider
    self.hunt = hunt
    initialSetup()
  }

  private func initialSetup() {
    setupObservers()

    if hunt.hasIntroduction {
      huntState = .showIntroduction(introduction: hunt.unwrappedIntroduction)
    } else {
      setFirstStation()
    }
  }

  private func setupObservers() {
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
      .sink { [weak self] huntState in
        if case .findStation(let station) = huntState {
          self?.changeLocation(station.location)
        } else if case .findOutline(let outlineLocation) = huntState {
          self?.changeLocation(outlineLocation)
        }
      }
      .store(in: &cancellables)
  }

  private func changeLocation(_ location: THLocation?) {
    guard let location else { return }
    locationProvider.updateCurrentLocation(to: location)
  }

  private func onDistanceUpdate(_ distance: CLLocationDistance) {
    guard distance > 0 else { return }

    self.distanceToCurrentLocation = distance
    HapticManager.shared.triggerFeedback(on: distance)

    if shouldShowTask() {
      showTask()
    }

    if shouldShowOutline() {
      showOutline()
    }
  }

  func didTapNextStationButton() {
    if case .findStation(let station) = huntState {
      THStationModelService.completeStation(station)
    }

    if isLastStation && hunt.hasOutline {
      setOutlineLocation()
    } else {
      setNextStation()
    }

    audioPlayer.leftStation()
  }

  func setFirstStation() {
    do {
      let firstStation = try getFirstStation()
      self.huntState = .findStation(station: firstStation)
    } catch let error as HuntError {
      self.error = error
    } catch {
      fatalError("Error not implemented, \(error)")
    }
  }

  private func setNextStation() {
    guard
      let currentIndex = currentStationsIndex,
      currentIndex < hunt.stationsArray.count,
      let nextStation = hunt.stationsArray[safe: currentIndex + 1]
    else { return }

    huntState = .findStation(station: nextStation)
  }

  private func setOutlineLocation() {
    guard let outlineLocation = hunt.outlineLocation else { return }
    huntState = .findOutline(outlineLocation: outlineLocation)
  }

  private func getFirstStation() throws -> THStation {
    if let firstStation = hunt.stationsArray.first {
      return firstStation
    }
    throw HuntError.noStations
  }

  private func shouldShowTask() -> Bool {
    guard case .findStation(let station) = huntState else { return false }
    return isNearCurrentLocation && !station.isCompleted && !station.unwrappedTask.isEmpty
  }

  private func showTask() {
    guard case .findStation(let station) = huntState else { return }
    huntState = .showTask(task: station.unwrappedTask)
  }

  private func shouldShowOutline() -> Bool {
    guard case .findOutline = huntState else { return false }
    return isNearCurrentLocation && hunt.hasOutline
  }

  private func showOutline() {
    huntState = .showOutline(outline: hunt.unwrappedOutline)
  }
}
