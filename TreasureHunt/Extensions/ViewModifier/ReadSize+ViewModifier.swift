//
//  ReadSize+ViewModifier.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 28.10.22.
//

import SwiftUI

struct SizePreferenceKey: PreferenceKey {
  static var defaultValue: CGSize = .zero
  static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

extension View {
  func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
    background(
      GeometryReader { geo in
        Color.clear
          .preference(key: SizePreferenceKey.self, value: geo.size)
      }
    )
    .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
  }
}

