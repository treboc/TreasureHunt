//  Created by Dominik Hauser on 05/04/2021.
//  Copyright © 2021 dasdom. All rights reserved.
//

import SwiftUI
import MapKit

struct DirectionDistanceView: View {
  @Binding var angle: Double
  @Binding var distance: Double

  let error: Error? = nil

  private let distanceFormatter: MKDistanceFormatter = {
    let formatter = MKDistanceFormatter()
    formatter.unitStyle = MKDistanceFormatter.DistanceUnitStyle.default
    return formatter
  }()
  
    var body: some View {
      VStack {
        Image(systemName: "location.north.fill")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .rotationEffect(Angle(degrees: angle))
          .frame(height: 150)
          .accessibilityHidden(true)
          .padding()
        
        if let error = error {
          Text(verbatim: "\(error.localizedDescription)")
            .padding()
        } else if distance > 0 {
          Text(distanceFormatter.string(fromDistance: distance))
            .font(.headline)
            .padding()
        } else {
          EmptyView()
        }
      }
    }
}

struct DirectionDistance_Previews: PreviewProvider {
    static var previews: some View {
      DirectionDistanceView(angle: .constant(30), distance: .constant(30))
      .previewLayout(.sizeThatFits)
    }
}
