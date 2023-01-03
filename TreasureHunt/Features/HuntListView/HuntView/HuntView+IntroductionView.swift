//
//  HuntView+IntroductionView.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 15.12.22.
//

import SwiftUI

extension HuntView {
  struct IntroductionView: View {
    let introduction: String?
    let onDismiss: () -> Void

    var body: some View {
      NavigationView {
        Group {
          if let introduction {
            VStack {
              ScrollView(.vertical, showsIndicators: false) {
                Text(introduction)
                  .frame(maxWidth: .infinity, alignment: .leading)
                  .padding()
              }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(alignment: .bottom) {
              Button("Let's go!", action: onDismiss)
                .foregroundColor(.label)
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
          } else {
            noIntroductionPlaceholder
          }
        }
        .scrollContentBackground(.hidden)
        .gradientBackground()
        .navigationTitle("Introduction")
        .interactiveDismissDisabled()
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
