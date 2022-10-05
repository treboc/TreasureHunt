//  Created by dasdom on 30.12.19.
//  Copyright © 2019 dasdom. All rights reserved.
//

import Foundation

extension FileManager {
  private func documentsURL() -> URL {
    guard let url = FileManager.default.urls(
      for: .documentDirectory,
      in: .userDomainMask).first else {
        fatalError()
    }
    return url
  }
  
  func stationsURL() -> URL {
    return documentsURL().appendingPathComponent("stations.json")
  }

  var huntsStoreURL: URL {
    return documentsURL().appendingPathComponent("hunts.json", conformingTo: .json)
  }
}
