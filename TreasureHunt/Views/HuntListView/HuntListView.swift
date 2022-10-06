//
//  HuntListView.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 03.10.22.
//

import SwiftUI

struct HuntListView: View {
  @StateObject private var huntsStore = HuntsStore()
  @StateObject private var viewModel = HuntListViewModel()

  var body: some View {
    NavigationStack {
      ZStack {
        if huntsStore.allHunts.isEmpty {
          noHuntsPlaceholder
        } else {
          List {
            ForEach(huntsStore.allHunts) { hunt in
              NavigationLink(destination: HuntListDetailView(hunt: hunt)) {
                HuntListRowView(hunt: hunt)
              }
            }
            .onDelete(perform: huntsStore.deleteHunt)
          }
        }
      }
      .sheet(isPresented: $viewModel.newHuntViewIsShown, content: AddHuntView.init)
      .toolbar(content: toolbarContent)
      .navigationTitle("Jagden")
      .environmentObject(huntsStore)
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
      Button(iconName: "plus", action: viewModel.showNewHuntView)
    }
  }

  private var noHuntsPlaceholder: some View {
    VStack(spacing: 30) {
      Text("Du hast noch keine Jagd erstellt. Deine erste Jagd kann du erstellen in dem du hier tippst, oder oben rechts auf das \"+\".")
        .multilineTextAlignment(.center)
        .font(.system(.headline, design: .rounded))
      Button("Erstelle eine Jagd", action: viewModel.showNewHuntView)
        .foregroundColor(Color(uiColor: .systemBackground))
        .buttonStyle(.borderedProminent)
        .controlSize(.regular)
    }
    .padding(.horizontal, 50)
  }
}

