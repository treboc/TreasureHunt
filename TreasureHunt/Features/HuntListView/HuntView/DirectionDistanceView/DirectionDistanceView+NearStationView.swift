//
//  DirectionDistanceView+NearStationView.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 20.12.22.
//

import SwiftUI

extension DirectionDistanceView {
  struct NearStationView: View {
    let isCompleted: Bool
    let stationTitle: String
    let stationNo, stationsCount: Int
    let namespace: Namespace.ID

    @State private var isAnimated: Bool = false

    var body: some View {
      HStack {
        VStack(alignment: .leading) {
          Image(systemName: isCompleted ? "checkmark.circle" : "circle")
            .resizable()
            .frame(width: 30, height: 30)

          Text(stationTitle)
            .font(.system(.title, design: .rounded))
            .fontWeight(.semibold)
            .lineLimit(1)

          Text(L10n.HuntView.DirectionDistanceView.stationOf(stationNo,
                                                             stationsCount))
          .font(.system(.headline, design: .rounded))
          .italic()
          .foregroundColor(.secondary)
        }

        Spacer()

        Image(systemName: "hand.point.down.fill")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .accessibilityHidden(true)
          .padding()
          .foregroundColor(.green)
          .frame(height: 100)
          .offset(y: isAnimated ? -10 : 10)
          .animation(.easeInOut(duration: 0.5).repeatForever(), value: isAnimated)
          .matchedGeometryEffect(id: "arrow", in: namespace)
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

#if DEBUG
struct NearStationVIew_Previews: PreviewProvider {
  static let namespace = Namespace()
  static var previews: some View {
    DirectionDistanceView.NearStationView(isCompleted: true,
                                          stationTitle: "Dummy Station",
                                          stationNo: 1,
                                          stationsCount: 4,
                                          namespace: namespace.wrappedValue)
  }
}
#endif
