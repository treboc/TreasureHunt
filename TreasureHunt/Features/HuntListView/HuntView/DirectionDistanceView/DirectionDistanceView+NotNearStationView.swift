//
//  DirectionView+NotNearStationView.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 20.12.22.
//

import SwiftUI

extension DirectionView {
  struct NotNearstationView: View {
    @AppStorage("arrowIcon") private var arrowIcon: ArrowIconPicker.ArrowIcon = .locationNorthFill

    private let distanceFormatter: LengthFormatter = {
      let formatter = LengthFormatter()
      formatter.unitStyle = .short
      return formatter
    }()

    private var distanceString: String {
      distanceFormatter.string(fromMeters: distanceToStation)
    }

    private var arrowColor: Color {
      switch distanceToStation {
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

    let stationNumber, numberOfStations: Int
    let angle, distanceToStation: Double
    let namespace: Namespace.ID

    var body: some View {
      VStack {
        Group {
          if stationNumber != 0 {
            Text(L10n.HuntView.DirectionDistanceView.stationOf(stationNumber, numberOfStations))
          } else {
            Text("Last Location")
          }
        }
        .font(.system(.largeTitle, design: .rounded))
        .fontWeight(.semibold)
        .padding(.top)

        Spacer()

        VStack {
          Image(systemName: arrowIcon.systemImage)
            .font(.system(size: 240))
            .rotationEffect(Angle(degrees: angle))
            .accessibilityHidden(true)
            .padding()
            .foregroundColor(arrowColor)
            .matchedGeometryEffect(id: "arrow", in: namespace)

          if distanceToStation > 0 {
            Text(distanceString)
              .font(.headline)
              .padding()
          } else {
            Text(L10n.HuntView.DirectionDistanceView.distanceNA)
          }
        }

        Spacer()
      }
    }
  }
}

#if DEBUG
struct NotNearStationView_Previews: PreviewProvider {
  static let namespace: Namespace = Namespace()

  static var previews: some View {
    DirectionView.NotNearstationView(stationNumber: 1,
                                             numberOfStations: 5,
                                             angle: 23,
                                             distanceToStation: 123,
                                             namespace: namespace.wrappedValue)
  }
}
#endif
