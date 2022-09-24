//  Created by Dominik Hauser on 21.09.22.
//  
//

import Combine
import Foundation
import CoreLocation

class StationsStore: ObservableObject {
  var cancellable: AnyCancellable?
  var index: Int = -1
  
  @Published var stations: [Station] = []
  @Published var currentStation: Station?

  init() {
    loadStationsFromDisk()
    if let station = stations.first {
      currentStation = station
    }

    cancellable = $stations
      .receive(on: RunLoop.main)
      .sink { [weak self] _ in
        self?.writeStationsToDisk()
      }
  }

  private func loadStationsFromDisk() {
    do {
      let data = try Data(contentsOf: FileManager.default.stationsURL())
      self.stations = try JSONDecoder().decode([Station].self, from: data)
    } catch {
      self.stations = []
    }
  }

  private func writeStationsToDisk() {
    do {
      let data = try JSONEncoder().encode(stations)
      try data.write(to: FileManager.default.stationsURL())
    } catch {
      print("\(#file), \(#line): \(error)")
    }
  }

  func next() -> Station? {
    let nextIndex = index + 1
    guard stations.count > nextIndex else {
      return nil
    }
    index = nextIndex
    return stations[nextIndex]
  }

  func previous() -> Station? {
    guard index > 0 else {
      return nil
    }
    index = index - 1
    return stations[index]
  }

  func setNextStation() {
    currentStation = next()
  }

  func newStation(with name: String, question: String, and location: CLLocationCoordinate2D) {
    
    let station = Station(clCoordinate: location, name: name)
    stations.append(station)
  }

  func deleteStation(at offsets: IndexSet) {
    stations.remove(atOffsets: offsets)
  }
}
