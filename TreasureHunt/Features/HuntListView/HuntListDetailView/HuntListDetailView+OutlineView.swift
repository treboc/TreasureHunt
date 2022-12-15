//
//  HuntListDetailView+OutlineView.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 12.12.22.
//

import SwiftUI

extension HuntListDetailView {
  struct OutlineView: View {
    let outline: String
    var outlineLocation: THLocation? = nil
    @State private var size: CGSize = .zero

    var body: some View {
      VStack(alignment: .leading, spacing: 10) {
        Text(outline)

        if let outlineLocation {
          Text(outlineLocation.unwrappedTitle)
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding()
      .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: Constants.cornerRadius))
      .readSize(onChange: setTitleLabelOffset)
      .overlay(alignment: .leading) {
        // Introduction
        Text("Outline")
          .foregroundColor(.black)
          .padding(10)
          .background(
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
              .fill(.tint)
              .shadow(radius: 3)
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
