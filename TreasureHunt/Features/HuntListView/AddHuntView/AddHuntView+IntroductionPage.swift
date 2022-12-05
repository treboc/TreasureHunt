//
//  AddHuntView+IntroductionPage.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 19.11.22.
//

import SwiftUI

extension AddHuntView {
  struct IntroductionPage: View {
    let pageIndex: PageSelection
    @Binding var hasIntroduction: Bool
    @Binding var introduction: String
    let placeholder: String = "Just some words, to introduce the story of the hunt."
    @FocusState private var isFocused

    var body: some View {
      HStack(alignment: .firstTextBaseline) {
        THNumberedCircle(number: 2)

        VStack(alignment: .leading) {
          Text("Does your hunt has an introduction?")
            .font(.system(.title3, design: .rounded, weight: .semibold))
          Text("Here you could put some form of introduction to your hunt or story. This text will show up when starting the hunt.")
            .font(.system(.footnote, design: .rounded, weight: .regular))
            .foregroundColor(.secondary)

          THToggle(isSelected: $hasIntroduction)

          if hasIntroduction {
            TextField(placeholder, text: $introduction, axis: .vertical)
              .lineLimit(3...10)
              .padding()
              .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: Constants.cornerRadius))
              .transition(.opacity.combined(with: .move(edge: .bottom)))
              .focused($isFocused)
              .onChange(of: pageIndex) { index in
                if index != .name {
                  isFocused = false
                }
              }
          }
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
      .animation(.easeInOut(duration: 0.3), value: hasIntroduction)
      .padding()
    }
  }
}