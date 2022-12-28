//
//  RebuildableView+ViewModifier.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 26.12.22.
//

import SwiftUI

struct RebuildableView<Value: Equatable>: ViewModifier {
  @State private var id: UUID = UUID()
  let value: Value

  func body(content: Content) -> some View {
    content
      .id(id)
      .onChange(of: value, perform: rebuildView)
  }

  private func rebuildView(_ value: some Equatable) {
    id = UUID()
  }
}

extension View {
  func rebuildOnChange(of value: some Equatable) -> some View {
    modifier(
      RebuildableView(value: value)
    )
  }
}

