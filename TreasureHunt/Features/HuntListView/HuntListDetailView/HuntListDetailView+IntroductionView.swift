//
//  HuntListDetailView+IntroductionView.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 12.12.22.
//

import SwiftUI

extension HuntListDetailView {
  struct IntroductionView: View {
    let introduction: String
    @State private var size: CGSize = .zero

    var body: some View {
      VStack(alignment: .leading, spacing: 10) {
        Text(introduction)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding()
      .roundedBackground(shadowRadius: Constants.Shadows.secondLevel)
      .readSize(onChange: setTitleLabelOffset)
      .overlay(alignment: .leading) {
        Text("Introduction")
          .foregroundColor(.label)
          .padding(10)
          .background(
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
              .fill(.tint)
              .shadow(radius: Constants.Shadows.firstLevel)
          )
          .offset(x: 10, y: -(size.height / 2) - 10)
      }
      .padding(.horizontal)
      .padding(.top, 30)
    }

    private func setTitleLabelOffset(_ size: CGSize) {
      self.size = size
    }
  }
}

