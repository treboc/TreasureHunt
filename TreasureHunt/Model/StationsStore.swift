//  Created by Dominik Hauser on 21.09.22.
//
//

import Combine
import Foundation
import CoreLocation

class StationsStore: ObservableObject {
  var cancellable: AnyCancellable?
  var index: Int = -1
  
  @Published var allStations: [Station] = []

  init() {
    loadStationsFromDisk()
    
    cancellable = $allStations
      .dropFirst()
      .receive(on: RunLoop.main)
      .sink { [weak self] _ in
        self?.writeStationsToDisk()
      }
  }

  private func loadStationsFromDisk() {
    do {
      let data = try Data(contentsOf: FileManager.default.stationsURL())
      self.allStations = try JSONDecoder().decode([Station].self, from: data)
    } catch {
      self.allStations = []
    }
  }

  private func writeStationsToDisk() {
    do {
      let data = try JSONEncoder().encode(allStations)
      try data.write(to: FileManager.default.stationsURL(), options: .atomic)
    } catch {
      print("\(#file), \(#line): \(error)")
    }
  }

  func newStation(with name: String, triggerDistance: Double, question: String, and location: CLLocationCoordinate2D) {
    let station = Station(clCoordinate: location, triggerDistance: triggerDistance, name: name, question: question)
    allStations.append(station)
  }

  func deleteStation(at offsets: IndexSet) {
    allStations.remove(atOffsets: offsets)
  }

  func moveStation(from source: IndexSet, to destination: Int) {
    allStations.move(fromOffsets: source, toOffset: destination)
  }
}
