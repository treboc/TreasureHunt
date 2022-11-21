//
//  AddHuntStationAnnotationView.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 26.09.22.
//

import SwiftUI

struct AddHuntStationAnnotationView: View {
  let position: Int

  var body: some View {
    VStack(spacing: 0) {
      Image(systemName: "\(position).circle.fill")
        .resizable()
        .renderingMode(.original)
        .frame(width: 30, height: 30)
        .foregroundColor(.accentColor)

      Image(systemName: "triangle.fill")
        .resizable()
        .scaledToFit()
        .foregroundColor(.primaryAccentColor)
        .frame(width: 10, height: 10)
        .rotationEffect(.degrees(180))
        .offset(y: -3)
        .padding(.bottom, 40)
    }
  }
}
