//
//  TextfieldWithTitle.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 16.10.22.
//

import SwiftUI

extension AddNewStationView {
  struct TextfieldWithTitle: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    @FocusState var focusField: Field?
    let field: Field?

    var body: some View {
      VStack(alignment: .leading, spacing: 2) {
        Text(title.uppercased())
          .foregroundColor(.secondary)
          .font(.caption)
          .padding(.leading)

        TextField(placeholder, text: $text)
          .focused($focusField, equals: field)
          .padding(.vertical, 10)
          .padding(.horizontal)
          .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))
      }
    }
  }
}
