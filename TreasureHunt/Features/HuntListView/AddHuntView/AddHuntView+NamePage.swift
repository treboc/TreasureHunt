//
//  AddHuntView+NamePage.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 19.11.22.
//

import SwiftUI

extension AddHuntView {
  struct NamePage: View {
    let pageIndex: PageSelection
    @Binding var name: String
    @FocusState private var isFocused

    var body: some View {
      HStack(alignment: .firstTextBaseline) {
        THNumberedCircle(number: 1)

        VStack(alignment: .leading) {
          Text("Name")
            .font(.system(.title3, design: .rounded, weight: .semibold))
          Text("Name it, so you find it again later.")
            .font(.system(.footnote, design: .rounded, weight: .regular))
            .foregroundColor(.secondary)

          TextField("e.g. Kids Birthday 🥳", text: $name)
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: Constants.cornerRadius))
            .focused($isFocused)
            .onChange(of: pageIndex) { index in
              if index != .name {
                isFocused = false
              }
            }
          
          Spacer()
        }
      }
      .onTapGesture {
        if isFocused {
          isFocused = false
        }
      }
      .padding()
    }
  }
}
