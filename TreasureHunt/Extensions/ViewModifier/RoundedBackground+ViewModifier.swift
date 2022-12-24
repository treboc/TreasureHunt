//
//  RoundedBackground+ViewModifier.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 24.12.22.
//

import SwiftUI

struct RoundedBackground: ViewModifier {
  let cornerRadius: CGFloat
  let shadowRadius: CGFloat

  func body(content: Content) -> some View {
    content
      .background(
        RoundedRectangle(cornerRadius: cornerRadius)
          .fill(.ultraThinMaterial)
          .shadow(radius: shadowRadius)
      )
  }
}

extension View {
  func roundedBackground(cornerRadius: CGFloat = Constants.cornerRadius,
                         shadowRadius: CGFloat = Constants.Shadows.firstLevel) -> some View {
    modifier(
      RoundedBackground(cornerRadius: cornerRadius,
                        shadowRadius: shadowRadius)
    )
  }
}
