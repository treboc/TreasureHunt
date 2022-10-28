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
        Image(systemName: "\(position).circle.fill")
          .font(.title3)
          .foregroundStyle(Color.accentColor)

        HStack(alignment: .top) {
          // title
          VStack(alignment: .leading, spacing: 2) {
            Text(L10n.HuntListDetailRowView.stationName.localizedUppercase)
              .font(.system(.caption2, design: .rounded))
              .foregroundColor(.secondary)

            Text(station.name)
              .font(.system(.title2, design: .rounded, weight: .semibold))
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

      // question & answer
      if station.question.isEmpty == false {
        Divider()

        VStack(alignment: .leading, spacing: 2) {
          Text(L10n.HuntListDetailRowView.question.localizedUppercase)
            .font(.system(.caption2, design: .rounded))
            .foregroundColor(.secondary)

          Text(station.question)
            .font(.system(.headline, design: .rounded))
            .lineLimit(0)
            .multilineTextAlignment(.leading)
        }
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding()
    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .circular))
    .padding(.horizontal)
  }
}
