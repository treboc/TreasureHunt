//
//  HuntListRowView.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 04.10.22.
//

import SwiftUI

struct HuntListRowView: View {
  let hunt: Hunt

  var body: some View {
    VStack(alignment: .leading, spacing: 5) {
      Text(hunt.name)
        .font(.headline)
        .fontWeight(.semibold)

      Text(L10n.huntListRowViewStationsCount(hunt.stations.count))
        .italic()
        .font(.callout)

      Group {
        Text(L10n.HuntListRowView.created) +
        Text(hunt.createdAt, format: .dateTime)
      }
      .foregroundColor(.secondary)
      .font(.caption)
    }
    .padding(.vertical, 4)
  }
}
