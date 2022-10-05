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

      Text("\(hunt.stations.count) Stationen")
        .italic()
        .font(.callout)

      HStack {
        Text("Erstellt:")
        Text(hunt.createdAt, format: .dateTime)
      }
      .foregroundColor(.secondary)
      .font(.caption)
    }
    .padding(.vertical, 4)
  }
}
