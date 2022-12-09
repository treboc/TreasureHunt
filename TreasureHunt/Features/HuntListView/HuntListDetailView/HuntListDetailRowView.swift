//
//  HuntListDetailRowView.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 28.10.22.
//

import SwiftUI

struct HuntListDetailRowView: View {
  @EnvironmentObject private var locationProvider: LocationProvider
  @ObservedObject var station: THStation
  let position: Int

  @State private var isEditingStation: Bool = false
  @State private var horizontalOffset: CGFloat = .zero
  
  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      HStack(alignment: .bottom) {
        VStack(alignment: .leading, spacing: 2) {
          Text(station.unwrappedTitle)
            .font(.system(.title2, design: .rounded, weight: .semibold))
            .lineLimit(2)

          Text(L10n.HuntListDetailRowView.stationName.localizedUppercase)
            .font(.system(.caption2, design: .rounded))
            .foregroundColor(.secondary)
        }

        Spacer()

        if station.location != nil {
          VStack(alignment: .trailing, spacing: 2) {
            Text(locationProvider.distanceToAsString(station.location?.location))
              .font(.system(.subheadline, design: .rounded))

            Text(L10n.HuntListDetailRowView.distanceFromHere.localizedUppercase)
              .font(.system(.caption2, design: .rounded))
              .foregroundColor(.secondary)
          }
        } else {
          VStack {
            Image(systemName: "exclamationmark.circle.fill")
              .font(.headline)
              .foregroundColor(.red)

            Text("This Station does not have a location, tap here, to edit the station!")
              .font(.footnote)
              .foregroundColor(.secondary)
          }
          .onTapGesture { isEditingStation = true }
        }
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding()
    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: Constants.cornerRadius))
    .readSize(onChange: setHorizontalOffset)
    .overlay {
      Image(systemName: "\(position).circle.fill")
        .font(.title3)
        .foregroundStyle(Color.accentColor)
        .offset(x: horizontalOffset)
    }
    .padding(.horizontal)
    .sheet(isPresented: $isEditingStation) {
      AddStationView(station: station)
    }
  }
}

extension HuntListDetailRowView {
  private func setHorizontalOffset(_ viewSize: CGSize) {
    horizontalOffset = -(viewSize.width / 2)
  }
}
