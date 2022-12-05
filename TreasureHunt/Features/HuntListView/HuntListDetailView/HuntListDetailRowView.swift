//
//  HuntListDetailRowView.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 28.10.22.
//

import SwiftUI

struct HuntListDetailRowView: View {
  @EnvironmentObject private var locationProvider: LocationProvider
  let station: THStation
  let position: Int
  
  @State private var horizontalOffset: CGFloat = .zero
  
  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      HStack(alignment: .bottom) {
        VStack(alignment: .leading, spacing: 2) {
          Text(station.name)
            .font(.system(.title2, design: .rounded, weight: .semibold))
            .lineLimit(2)
          
          Text(L10n.HuntListDetailRowView.stationName.localizedUppercase)
            .font(.system(.caption2, design: .rounded))
            .foregroundColor(.secondary)
        }
        
        Spacer()
        
        VStack(alignment: .trailing, spacing: 2) {
          Text(locationProvider.distanceToAsString(station.location?.location))
            .font(.system(.subheadline, design: .rounded))
          
          Text(L10n.HuntListDetailRowView.distanceFromHere.localizedUppercase)
            .font(.system(.caption2, design: .rounded))
            .foregroundColor(.secondary)
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
  }
}

extension HuntListDetailRowView {
  private func setHorizontalOffset(_ viewSize: CGSize) {
    horizontalOffset = -(viewSize.width / 2)
  }
}

struct HuntListDetailRowView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      HuntListDetailRowView(station: .station, position: 1)

      HuntListDetailRowView(station: .station, position: 1)
        .padding()
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
  }
}