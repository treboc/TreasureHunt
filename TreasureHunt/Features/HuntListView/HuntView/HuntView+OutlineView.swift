//
//  HuntView+OutlineView.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 22.12.22.
//

import SwiftUI

extension HuntView {
  struct OutlineView: View {
    let outline: String?
    let didTapEndHuntButton: () -> Void

    var body: some View {
      NavigationView {
        ScrollView(.vertical, showsIndicators: false) {
          if let outline {
            VStack {
              Text(outline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()

              Button("End Hunt", action: didTapEndHuntButton)
                .foregroundColor(.label)
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
          } else {
            noOutlinePlaceholder
          }
        }
        .navigationTitle("Introduction")
        .interactiveDismissDisabled()
      }
    }

    private var noOutlinePlaceholder: some View {
      Text("No Introduction Set")
        .font(.title3)
        .fontWeight(.semibold)
        .foregroundColor(.secondary)
    }
  }
}

#if DEBUG
struct OutlineView_Previews: PreviewProvider {
  static var previews: some View {
    HuntView.OutlineView(outline: "This is just a sample outline") {
      print("dismissed")
    }
  }
}
#endif
