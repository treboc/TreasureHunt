//
//  HuntListDetailView+StationRowView.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 28.10.22.
//

import SwiftUI

extension HuntListDetailView {
  struct StationRowView: View {
    @EnvironmentObject private var locationProvider: LocationProvider
    @ObservedObject var station: THStation
    @State private var noLocationAlertIsShown: Bool = false
    let index: Int

    @State private var verticalOffset: CGFloat = .zero

    var body: some View {
      VStack(alignment: .leading, spacing: 10) {
        HStack {
          Text(station.unwrappedTitle)
            .font(.system(.title2, design: .rounded, weight: .semibold))
            .lineLimit(2)

          Spacer()

          if station.location != nil {
            VStack(alignment: .trailing, spacing: 2) {
              Text(locationProvider.distanceTo(station.location?.location))
                .font(.system(.subheadline, design: .rounded))

              Text(L10n.HuntListDetailRowView.distanceFromHere.localizedUppercase)
                .font(.system(.caption2, design: .rounded))
                .foregroundColor(.secondary)
            }
          } else {
            HStack {
              Text("No Location")
              Image(systemName: "exclamationmark.circle.fill")
                .font(.headline)
                .foregroundColor(.red)
            }
            .contentShape(Rectangle())
            .onTapGesture { noLocationAlertIsShown.toggle() }
            .alert("No Location", isPresented: $noLocationAlertIsShown) {
              Button("OK") {}
            } message: {
              Text("Please edit the hunt and add a location.")
            }
          }
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding()
      .background(
        RoundedRectangle(cornerRadius: Constants.cornerRadius)
          .fill(.thinMaterial)
          .shadow(radius: Constants.Shadows.firstLevel)
      )
      .readSize(onChange: setHorizontalOffset)
      .overlay(alignment: .leading) {
        Image(systemName: "\(index + 1).circle.fill")
          .font(.title3)
          .foregroundStyle(Color.accentColor)
          .offset(x: 10, y: verticalOffset)
      }
      .padding(.top, 10)
    }

    private func setHorizontalOffset(_ viewSize: CGSize) {
      verticalOffset = -(viewSize.height / 2)
    }
  }
}
