//
//  LocationsListRowView.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 25.09.22.
//

import MapKit
import SwiftUI

struct LocationsListRowView: View {
  @EnvironmentObject private var locationProvider: LocationProvider
  @ObservedObject var location: THLocation
  @State private var yOffset: CGFloat = 0

  var body: some View {
    HStack {
      VStack(alignment: .leading, spacing: 5) {
        Text(location.unwrappedTitle)
          .font(.system(.body, design: .rounded, weight: .semibold))
          .fontWeight(.semibold)
      }

      Spacer()

      VStack(alignment: .trailing) {
        Text(locationProvider.distanceTo(location.location))
          .font(.system(.footnote, design: .rounded))
        Text(L10n.HuntListDetailRowView.distanceFromHere)
          .font(.system(.caption, design: .rounded, weight: .light))
      }
    }
    .padding(.vertical, 4)
    .frame(maxWidth: .infinity, alignment: .leading)
    .overlay(alignment: .trailing) {
      if location.isFavourite {
        Image(systemName: "star.fill")
          .foregroundColor(.yellow)
          .offset(y: yOffset)
      }
    }
    .padding()
    .roundedBackground()
    .listRowInsets(.init(top: Constants.rowSpacing, leading: 10, bottom: Constants.rowSpacing, trailing: 10))
    .listRowSeparator(.hidden)
    .listRowBackground(Color.clear)
    .contentShape(Rectangle())
    .readSize { size in
      yOffset = -(size.height / 2)
    }
  }
}
