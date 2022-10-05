//  Created by Dominik Hauser on 24.09.22.
//  
//

import SwiftUI

struct QuestionView: View {
  let station: Station

  var body: some View {
    Text(station.question)
      .padding()
  }
}
