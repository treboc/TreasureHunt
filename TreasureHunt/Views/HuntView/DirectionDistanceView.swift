//  Created by Dominik Hauser on 05/04/2021.
//  Copyright © 2021 dasdom. All rights reserved.
//

import SwiftUI
import MapKit

struct DirectionDistanceView: View {
  @AppStorage("arrowIcon") private var arrowIcon: ArrowIconPicker.ArrowIcon = .arrow

  @ObservedObject var huntManager: HuntManager
  private var currentStationNumber: Int? {
    guard let currentStation = huntManager.currentStation,
          let currentStationIndex = huntManager.stations.firstIndex(of: currentStation)
    else { return nil }
    return currentStationIndex + 1
  }

  @Namespace private var arrow
  @Namespace private var title

  private var arrowColor: Color {
    switch huntManager.distance {
    case 0..<50:
      return .green
    case 50..<100:
      return .yellow
    case 100..<250:
      return .orange
    case 250...:
      return .red
    default:
      return .primaryAccentColor
    }
  }

  private let distanceFormatter: MKDistanceFormatter = {
    let formatter = MKDistanceFormatter()
    formatter.unitStyle = MKDistanceFormatter.DistanceUnitStyle.default
    return formatter
  }()
  
  var body: some View {
    if huntManager.mapIsHidden {
      VStack {
        VStack {
          Text("Zweite Station")
            .font(.system(.largeTitle, design: .rounded))
            .fontWeight(.semibold)
            .padding(.top)

          if huntManager.currentStation != nil {
            Text("Station \(currentStationNumber ?? 0) von \(huntManager.stations.count)")
              .font(.system(.headline, design: .rounded))
              .foregroundColor(.secondary)
          }
        }

        Spacer()

        VStack {
          Image(systemName: arrowIcon.systemImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .rotationEffect(Angle(degrees: huntManager.angle))
            .frame(height: 150)
            .accessibilityHidden(true)
            .padding()
            .foregroundColor(arrowColor)
            .matchedGeometryEffect(id: "arrow", in: arrow)

          if huntManager.distance > 0 {
            Text(distanceFormatter.string(fromDistance: huntManager.distance))
              .font(.headline)
              .padding()
          } else {
            Text("Distance N/A")
          }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    } else {
      HStack {
        VStack(alignment: .leading) {
          Text("Zweite Station")
            .font(.system(.title, design: .rounded))
            .fontWeight(.semibold)
            .lineLimit(1)

          if huntManager.currentStation != nil {
            Text("Station \(currentStationNumber ?? 0) von \(huntManager.stations.count)")
              .font(.system(.headline, design: .rounded))
              .italic()
              .foregroundColor(.secondary)
          }
        }

        Spacer()

        VStack {
          Image(systemName: arrowIcon.systemImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .rotationEffect(Angle(degrees: huntManager.angle))
            .accessibilityHidden(true)
            .padding()
            .foregroundColor(arrowColor)
            .matchedGeometryEffect(id: "arrow", in: arrow)

          if huntManager.distance > 0 {
            Text("in **\(distanceFormatter.string(fromDistance: huntManager.distance))**")
              .font(.headline)
          } else {
            Text("Distance N/A")
          }
        }
        .frame(width: nil, height: 100)
      }
      .frame(maxWidth: .infinity, alignment: .top)
      .padding()
      .background(
        RoundedRectangle(cornerRadius: 16)
          .fill(.thinMaterial)
          .shadow(radius: 5)
      )
      .padding(.horizontal)
    }
  }
}
