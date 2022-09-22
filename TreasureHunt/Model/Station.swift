//  Created by Dominik Hauser on 21.09.22.
//  
//

import Foundation

struct Station: Codable {
  let coordinate: Coordinate
  let name: String
  var question: String?
}
