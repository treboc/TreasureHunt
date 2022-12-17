//
//  HuntView+IntroductionVIew.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 15.12.22.
//

import SwiftUI

extension HuntView {
  struct IntroductionView: View {
    @Environment(\.dismiss) private var dismiss
    let introduction: String?

    var body: some View {
      NavigationStack {
        ScrollView(.vertical, showsIndicators: false) {
          if let introduction {
            Text(introduction)
              .frame(maxWidth: .infinity, alignment: .leading)
              .padding()
          } else {
            noIntroductionPlaceholder
          }
        }
        .navigationTitle("Introduction")
        .toolbar { dismissButton }
      }
    }

    private var dismissButton: some View {
      Button(iconName: "xmark.circle.fill") {
        dismiss()
      }
    }

    private var noIntroductionPlaceholder: some View {
      Text("No Introduction Set")
        .font(.title3)
        .fontWeight(.semibold)
        .foregroundColor(.secondary)
    }
  }
}
