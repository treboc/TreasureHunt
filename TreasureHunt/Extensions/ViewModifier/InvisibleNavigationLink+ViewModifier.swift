//
//  InvisibleNavigationLink.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 07.12.22.
//

import SwiftUI

struct InvisibleNavigationLink<Destination: View>: ViewModifier {
  let destination: () -> Destination

  func body(content: Content) -> some View {
    content
      .overlay(
        NavigationLink(
          destination: { destination() },
          label: { EmptyView() }
        ).opacity(0)
      )
  }
}

extension View {
  func invisibleNavigationLink(@ViewBuilder _ destination: @escaping () -> some View) -> some View {
    modifier(InvisibleNavigationLink(destination: destination))
  }
}
