//  Created by Dominik Hauser on 05.11.21.
//  Copyright © 2021 dasdom. All rights reserved.
//

import Foundation
import CoreLocation

struct Coordinate: Codable, Equatable {
  let latitude: Double
  let longitude: Double

  init(latitude: Double, longitude: Double) {
    self.latitude = latitude
    self.longitude = longitude
  }

  init(clCoordinate: CLLocationCoordinate2D) {
    latitude = clCoordinate.latitude
    longitude = clCoordinate.longitude
  }
}
