//
//  EmptyState+ViewModifier.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 26.12.22.
//

import SwiftUI

struct EmptyStateViewModifier<EmptyContent>: ViewModifier where EmptyContent: View {
  var isEmpty: Bool
  let emptyContent: () -> EmptyContent

  func body(content: Content) -> some View {
    if isEmpty {
      emptyContent()
    } else {
      content
    }
  }
}

extension View {
  func emptyState<EmptyContent>(_ isEmpty: Bool,
                                emptyContent: @escaping () -> EmptyContent) -> some View where EmptyContent: View {
    modifier(EmptyStateViewModifier(isEmpty: isEmpty, emptyContent: emptyContent))
  }
}

struct EmptyStateView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      Image(systemName: "heart")
        .emptyState(true) {
          Text("Image is empty, will show this instead.")
        }
        .previewDisplayName("Empty State")

      Image(systemName: "heart")
        .emptyState(false) {
          Text("Image is not empty, Image will be shown.")
        }
        .previewDisplayName("Non-Empty State")
    }
  }
}
