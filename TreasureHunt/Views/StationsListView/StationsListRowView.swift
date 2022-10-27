//
//  StationsListRowView.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 25.09.22.
//

import MapKit
import SwiftUI

struct StationsListRowView: View {
  let station: Station

  var body: some View {
    VStack(alignment: .leading, spacing: 5) {
      Text(station.name)
        .font(.headline)
        .fontWeight(.semibold)

      if !station.question.isEmpty {
        Text("**Q:** *\(station.question)*")
          .foregroundColor(.secondary)
          .font(.caption)
      } else {
        Text(L10n.StationsListRowView.noQuestion)
          .italic()
          .foregroundColor(.secondary)
          .font(.caption)
      }
    }
    .padding(.vertical, 4)
    .frame(maxWidth: .infinity, alignment: .leading)
    .contentShape(Rectangle())
  }
}
