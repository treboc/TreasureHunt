//
//  StationsListRowView.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 25.09.22.
//

import MapKit
import RealmSwift
import SwiftUI

struct StationsListRowView: View {
  @EnvironmentObject private var locationProvider: LocationProvider
  let station: Station
  @State private var yOffset: CGFloat = 0

  func distanceToStation() -> String {
    if let distance = locationProvider.distanceTo(station.location) {
      return distance.asDistance()
    } else {
      return "N/A"
    }
  }

  var body: some View {
    HStack {
      VStack(alignment: .leading, spacing: 5) {
        Text(station.name)
          .font(.system(.title3, design: .rounded, weight: .semibold))
          .fontWeight(.semibold)
      }

      Spacer()

      VStack(alignment: .trailing) {
        Text(distanceToStation())

        Text(L10n.HuntListDetailRowView.distanceFromHere)
          .font(.system(.caption, design: .rounded, weight: .light))
      }
    }
    .padding(.vertical, 4)
    .frame(maxWidth: .infinity, alignment: .leading)
    .overlay(alignment: .trailing) {
      if station.isFavorite {
        Image(systemName: "star.fill")
          .foregroundColor(.yellow)
          .offset(y: yOffset)
      }
    }
    .padding()
    .background(
      RoundedRectangle(cornerRadius: 8)
        .fill(.regularMaterial)
    )
    .listRowInsets(.init(top: 10, leading: 10, bottom: 10, trailing: 10))
    .listRowSeparator(.hidden)
    .contentShape(Rectangle())
    .readSize { size in
      yOffset = -(size.height / 2)
    }
  }
}
