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
      Image(systemName: "arrow.up")
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
