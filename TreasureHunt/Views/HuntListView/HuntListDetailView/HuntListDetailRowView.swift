//
//  HuntListDetailRowView.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 28.10.22.
//

import SwiftUI

struct HuntListDetailRowView: View {
  @EnvironmentObject private var locationProvider: LocationProvider
  let station: Station
  let position: Int

  @State private var rowSize: CGSize = .zero

  func distanceToStation() -> String {
    if let distance = locationProvider.distanceTo(station.location) {
      return distance.asDistance()
    } else {
      return "N/A"
    }
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      HStack(alignment: .center) {
        HStack(alignment: .top) {
          // title
          VStack(alignment: .leading, spacing: 2) {
            Text(L10n.HuntListDetailRowView.stationName.localizedUppercase)
              .font(.system(.caption2, design: .rounded))
              .foregroundColor(.secondary)

            Text(station.name)
              .font(.system(.title2, design: .rounded, weight: .semibold))
              .lineLimit(2)
          }

          Spacer()

          // distance to station
          VStack(alignment: .trailing, spacing: 2) {
            Text(L10n.HuntListDetailRowView.distanceFromHere.localizedUppercase)
              .font(.system(.caption2, design: .rounded))
              .foregroundColor(.secondary)

            Text(distanceToStation())
              .font(.system(.subheadline, design: .rounded))
          }
        }
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding()
    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .circular))
    .readSize { size in
      rowSize = size
    }
    .overlay {
      Image(systemName: "\(position).circle.fill")
        .font(.title3)
        .foregroundStyle(Color.accentColor)
        .offset(x: -(rowSize.width / 2))
    }
    .padding(.horizontal)
  }
}
