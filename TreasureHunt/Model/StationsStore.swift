//  Created by Dominik Hauser on 21.09.22.
//  
//

import Foundation

class StationsStore: ObservableObject {

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
  }

  init() {

    do {
      let data = try Data(contentsOf: FileManager.default.stationsURL())
      self.stations = try JSONDecoder().decode([Station].self, from: data)
    } catch {
      self.stations = []
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

  func newStation(with name: String, and location: CLLocationCoordinate2D) {
    let station = Station(clCoordinate: location, name: name)
    stations.append(station)
  }

  func deleteStation(at offsets: IndexSet) {
    stations.remove(atOffsets: offsets)
  }
}
