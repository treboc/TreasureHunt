//
//  HuntListRowView.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 04.10.22.
//

import SwiftUI

struct HuntListRowView: View {
  let hunt: THHunt

  var body: some View {
    VStack(alignment: .leading, spacing: 5) {
      Text(hunt.title ?? "No Title")
        .font(.headline)
        .fontWeight(.semibold)

      Group {
        Text(L10n.HuntListRowView.created) +
        Text(hunt.unwrappedCreatedAt, format: .dateTime)
      }
      .foregroundColor(.secondary)
      .font(.caption)
    }
    .padding(.vertical, 4)
    .frame(maxWidth: .infinity, alignment: .leading)
    .overlay(alignment: .trailing, content: {
      Image(systemName: "chevron.right")
        .foregroundColor(.secondary)
    })
    .padding()
    .background(
      RoundedRectangle(cornerRadius: 8)
        .fill(.regularMaterial)
    )
    .listRowInsets(.init(top: 10, leading: 10, bottom: 10, trailing: 10))
    .listRowSeparator(.hidden)
    .listRowBackground(Color.clear)
    .contentShape(Rectangle())
  }
}
