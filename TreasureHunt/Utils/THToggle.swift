//
//  THToggle.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 20.11.22.
//

import SwiftUI

struct THToggle: View {
  @Namespace private var selection
  @Binding var isSelected: Bool

  var body: some View {
    HStack {
      Text("Yes")
        .foregroundColor(isSelected ? .label : .primary)
        .padding(.vertical, 6)
        .padding(.horizontal)
        .background(toggleBackground(isSelected, namespace: selection))
        .allowsHitTesting(!isSelected)
        .onTapGesture(perform: toggleIntroduction)

      Text("No")
        .foregroundColor(!isSelected ? .label : .primary)
        .padding(.vertical, 6)
        .padding(.horizontal)
        .background(toggleBackground(!isSelected, namespace: selection))
        .allowsHitTesting(isSelected)
        .onTapGesture(perform: toggleIntroduction)
    }
  }

  @ViewBuilder
  private func toggleBackground(_ isSelected: Bool, namespace: Namespace.ID) -> some View {
    if isSelected {
      RoundedRectangle(cornerRadius: Constants.cornerRadius)
        .fill(Color.accentColor)
        .matchedGeometryEffect(id: "background", in: namespace)
    } else {
      RoundedRectangle(cornerRadius: Constants.cornerRadius)
        .strokeBorder(Color.accentColor, lineWidth: 1)
    }
  }

  private func toggleIntroduction() {
    isSelected.toggle()
  }
}
