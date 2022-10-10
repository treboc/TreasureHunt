//  Created by Dominik Hauser on 05/04/2021.
//  Copyright © 2021 dasdom. All rights reserved.
//

import SwiftUI
import MapKit

struct DirectionDistanceView: View {
  @AppStorage("arrowIcon") private var arrowIcon: ArrowIconPicker.ArrowIcon = .arrow

  @ObservedObject var huntManager: HuntManager
  @State private var isAnimated: Bool = false
  @Namespace private var arrow

  private var arrowColor: Color {
    switch huntManager.distanceToCurrentStation {
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

  private let distanceFormatter: LengthFormatter = {
    let formatter = LengthFormatter()
    formatter.unitStyle = .short
    return formatter
  }()

  private var distanceString: String {
    distanceFormatter.string(fromMeters: huntManager.distanceToCurrentStation)
  }

  var body: some View {
    if huntManager.isNearCurrentStation == false {
      VStack {
        VStack {
          Text("Station \(huntManager.currentStationNumber ?? 0) von \(huntManager.hunt.stations.count)")
            .font(.system(.largeTitle, design: .rounded))
            .fontWeight(.semibold)
            .padding(.top)
        }

        Spacer()

        VStack {
          Image(systemName: arrowIcon.systemImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .rotationEffect(Angle(degrees: huntManager.angleToCurrentStation))
            .frame(height: 150)
            .accessibilityHidden(true)
            .padding()
            .foregroundColor(arrowColor)
            .matchedGeometryEffect(id: "arrow", in: arrow)

          if huntManager.distanceToCurrentStation > 0 {
            Text(distanceString)
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
          Image(systemName: huntManager.currentStation?.isCompleted ?? false ? "checkmark.circle" : "circle")
            .resizable()
            .frame(width: 30, height: 30)

          Text(huntManager.currentStation?.name ?? "Keine Station")
            .font(.system(.title, design: .rounded))
            .fontWeight(.semibold)
            .lineLimit(1)

          if huntManager.currentStation != nil {
            Text("Station \(huntManager.currentStationNumber ?? 0) von \(huntManager.hunt.stations.count)")
              .font(.system(.headline, design: .rounded))
              .italic()
              .foregroundColor(.secondary)
          }
        }

        Spacer()

        Image(systemName: "hand.point.down.fill")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .accessibilityHidden(true)
          .padding()
          .foregroundColor(arrowColor)
          .frame(height: 100)
          .offset(y: isAnimated ? -10 : 10)
          .animation(.easeInOut(duration: 0.5).repeatForever(), value: isAnimated)
          .onAppear { isAnimated.toggle() }
      }
      .frame(maxWidth: .infinity, alignment: .top)
      .padding()
      .background(
        RoundedRectangle(cornerRadius: 16)
          .fill(.thinMaterial)
          .shadow(radius: 5)
      )
      .padding(.horizontal)
      .transition(.opacity.combined(with: .scale))
    }
  }
}
