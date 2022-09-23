//  Created by Dominik Hauser on 21.09.22.
//  
//

import Foundation
import CoreLocation

struct Station: Codable, Identifiable {
  var id: UUID = UUID()
  let coordinate: Coordinate
  let name: String
  var question: String?

  init(clCoordinate: CLLocationCoordinate2D, name: String) {
    self.coordinate = Coordinate(clCoordinate: clCoordinate)
    self.name = name
  }
}
