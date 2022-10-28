//
//  PagePicker.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 16.10.22.
//

import SwiftUI

extension AddStationView {
  enum PageSelection: Int, CaseIterable, Identifiable {
    var id: Int {
      self.rawValue
    }

    case position, details
  }

  struct PagePicker: View {
    @Binding var selectedPage: PageSelection

    var body: some View {
      HStack {
        Button("Back") {
          selectedPage = .position
        }
        .controlSize(.regular)
        .buttonStyle(.borderedProminent)
        .foregroundColor(Color(uiColor: .systemBackground))
        .opacity(selectedPage == .details ? 1 : 0)

        Spacer()

        HStack {
          ForEach(PageSelection.allCases) { selectableCase in
            Circle()
              .fill(Color.white)
              .frame(width: 5, height: 5)
              .scaleEffect(selectableCase == selectedPage ? 1.5 : 1)
              .opacity(selectableCase == selectedPage ? 1 : 0.7)
          }
        }

        Spacer()

        Button("Next") {
          selectedPage = .details
        }
        .controlSize(.regular)
        .buttonStyle(.borderedProminent)
        .foregroundColor(Color(uiColor: .systemBackground))
        .opacity(selectedPage == .position ? 1 : 0)
      }
      .padding()
    }
  }
}
