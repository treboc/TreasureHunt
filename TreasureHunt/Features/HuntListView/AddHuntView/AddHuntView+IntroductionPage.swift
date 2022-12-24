//
//  AddHuntView+IntroductionPage.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 19.11.22.
//

import SwiftUI

extension AddHuntView {
  struct IntroductionPage: View {
    @EnvironmentObject private var viewModel: AddHuntViewModel
    @FocusState private var isFocused

    var body: some View {
      HStack(alignment: .firstTextBaseline) {
        THNumberedCircle(number: 2)

        VStack(alignment: .leading) {
          Text(L10n.AddHuntView.IntroductionPage.hasHuntIntroduction)
            .font(.system(.title3, design: .rounded, weight: .semibold))
          Text(L10n.AddHuntView.IntroductionPage.hasHuntIntroductionHint)
            .font(.system(.footnote, design: .rounded, weight: .regular))
            .foregroundColor(.secondary)

          THToggle(isSelected: $viewModel.hunt.hasIntroduction)

          if viewModel.hunt.hasIntroduction {
            TextField(L10n.AddHuntView.IntroductionPage.textFieldPlaceholder, text: $viewModel.hunt.unwrappedIntroduction, axis: .vertical)
              .lineLimit(3...10)
              .padding()
              .roundedBackground()
              .transition(.opacity.combined(with: .move(edge: .bottom)))
              .focused($isFocused)
              .onChange(of: viewModel.pageIndex) { index in
                if index != .name {
                  isFocused = false
                }
              }
          }
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
      .animation(.easeInOut(duration: 0.3), value: viewModel.hunt.hasIntroduction)
      .padding()
    }
  }
}
