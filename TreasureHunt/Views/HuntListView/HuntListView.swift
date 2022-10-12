//
//  HuntListView.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 03.10.22.
//

import RealmSwift
import SwiftUI

struct HuntListView: View {
  @ObservedResults(Hunt.self) private var hunts
  @State private var newHuntViewIsShown: Bool = false

  var body: some View {
    NavigationStack {
      ZStack {
        if hunts.isEmpty {
          noHuntsPlaceholder
        } else {
          List {
            ForEach(hunts) { hunt in
              NavigationLink(destination: HuntListDetailView(hunt: hunt)) {
                HuntListRowView(hunt: hunt)
              }
            }
            .onDelete(perform: HuntModelService.delete)
          }
        }
      }
      .sheet(isPresented: $newHuntViewIsShown, content: AddHuntView.init)
      .toolbar(content: toolbarContent)
      .navigationTitle("Jagden")
    }
  }
}

struct HuntListView_Previews: PreviewProvider {
  static var previews: some View {
    HuntListView()
  }
}

extension HuntListView {
  // MARK: - ToolbarItems
  @ToolbarContentBuilder
  private func toolbarContent() -> some ToolbarContent {
    ToolbarItem(placement: .navigationBarTrailing) {
      Button(iconName: "plus") { newHuntViewIsShown.toggle() }
        .accessibilityLabel("Jagd erstellen")
    }
  }

  private var noHuntsPlaceholder: some View {
    VStack(spacing: 30) {
      Text("Du hast noch keine Jagd erstellt. Deine erste Jagd kann du erstellen in dem du hier tippst, oder oben rechts auf das \"+\".")
        .multilineTextAlignment(.center)
        .font(.system(.headline, design: .rounded))
      Button("Erstelle eine Jagd")  { newHuntViewIsShown.toggle() }
        .foregroundColor(Color(uiColor: .systemBackground))
        .buttonStyle(.borderedProminent)
        .controlSize(.regular)
    }
    .padding(.horizontal, 50)
  }
}

