//  Created by Dominik Hauser on 21.09.22.
//  
//

import Foundation
import CoreLocation

struct Station: Codable, Identifiable {
  var id: UUID = UUID()
  let coordinate: Coordinate
  let triggerDistance: Double
  let name: String
  let question: String

  init(clCoordinate: CLLocationCoordinate2D, triggerDistance: Double = 5, name: String, question: String = "") {
    self.coordinate = Coordinate(clCoordinate: clCoordinate)
    self.triggerDistance = triggerDistance
    self.name = name
    self.question = question
  }

  var location: CLLocation {
    return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
  }
}
