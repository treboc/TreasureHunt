//  Created by Dominik Hauser on 21.09.22.
//  
//

import Foundation

class StationsStore {

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
}
