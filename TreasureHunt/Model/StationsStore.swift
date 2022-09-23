//  Created by Dominik Hauser on 21.09.22.
//  
//

import Foundation

class StationsStore: ObservableObject {

  var index: Int = -1

  var stations: [Station] {
    didSet {
      do {
        let data = try JSONEncoder().encode(stations)
        try data.write(to: FileManager.default.stationsURL())
      } catch {
        print("\(#file), \(#line): \(error)")
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

  func delete(at offsets: IndexSet) {
    stations.remove(atOffsets: offsets)
  }
}
