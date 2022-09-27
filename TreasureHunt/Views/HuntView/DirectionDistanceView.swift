//  Created by Dominik Hauser on 05/04/2021.
//  Copyright © 2021 dasdom. All rights reserved.
//

import SwiftUI
import MapKit

struct DirectionDistanceView: View {
  @AppStorage("arrowIcon") private var arrowIcon: ArrowIconPicker.ArrowIcon = .arrow

  @Binding var angle: Double
  @Binding var distance: Double

  private var arrowColor: Color {
    switch distance {
    case 0..<50:
      return .green
    case 50..<100:
      return .yellow
    case 100..<250:
      return .orange
    case 250...:
      return .red
    default:
      return .accentColor
    }
  }
  let error: Error? = nil

  private let distanceFormatter: MKDistanceFormatter = {
    let formatter = MKDistanceFormatter()
    formatter.unitStyle = MKDistanceFormatter.DistanceUnitStyle.default
    return formatter
  }()
  
  var body: some View {
    VStack {
      Image(systemName: arrowIcon.systemImage)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .rotationEffect(Angle(degrees: angle))
        .frame(height: 150)
        .accessibilityHidden(true)
        .padding()
        .foregroundColor(arrowColor)

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
