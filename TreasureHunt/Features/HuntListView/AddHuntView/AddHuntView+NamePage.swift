//
//  AddHuntView+NamePage.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 19.11.22.
//

import SwiftUI

extension AddHuntView {
  struct NamePage: View {
    @EnvironmentObject private var viewModel: AddHuntViewModel
    @FocusState private var isFocused

    var body: some View {
      HStack(alignment: .firstTextBaseline) {
        THNumberedCircle(number: 1)

        VStack(alignment: .leading) {
          Text(L10n.AddHuntView.NamePage.name)
            .font(.system(.title3, design: .rounded, weight: .semibold))
          Text(L10n.AddHuntView.NamePage.nameHint)
            .font(.system(.footnote, design: .rounded, weight: .regular))
            .foregroundColor(.secondary)

          TextField(L10n.AddHuntView.NamePage.namePlaceholder, text: $viewModel.hunt.unwrappedTitle)
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: Constants.cornerRadius))
            .focused($isFocused)
            .onChange(of: viewModel.pageIndex) { index in
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
