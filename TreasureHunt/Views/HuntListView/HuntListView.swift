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
  @State private var huntDeletionAlertIsShown: Bool = false
  @State private var huntToDelete: Hunt? = nil

  var body: some View {
    NavigationStack {
      ZStack {
        if hunts.isEmpty {
          noHuntsPlaceholder
        } else {
          List {
            ForEach(hunts) { hunt in
              HuntListRowView(hunt: hunt)
                .overlay(
                  NavigationLink(
                    destination: { HuntListDetailView(hunt: hunt) },
                    label: { EmptyView() }
                  ).opacity(0)
                )
              .swipeActions {
                swipeToDelete(hunt)
              }
            }
          }
          .listStyle(.plain)
        }
      }
      .alert(L10n.Alert.DeleteHunt.title, isPresented: $huntDeletionAlertIsShown, actions: {
        Button(L10n.BtnTitle.cancel, role: .cancel) {}
        Button(L10n.BtnTitle.iAmSure, role: .destructive) {
          if let huntToDelete {
            withAnimation {
              $hunts.remove(huntToDelete)
            }
          }
        }
      }, message: {
        Text(L10n.Alert.DeleteHunt.message)
      })
      .animation(.default, value: huntDeletionAlertIsShown)
      .sheet(isPresented: $newHuntViewIsShown) {
        AddHuntView()
      }
      .toolbar(content: toolbarContent)
      .navigationTitle(L10n.SimpleConstants.hunts)
    }
  }
}

struct HuntListView_Previews: PreviewProvider {
  static var previews: some View {
    HuntListView()
  }
}

extension HuntListView {
  private func swipeToDelete(_ hunt: Hunt) -> some View {
    Button {
      huntToDelete = hunt
      huntDeletionAlertIsShown = true
    } label: {
      Label(L10n.BtnTitle.delete, systemImage: "trash")
        .labelStyle(.iconOnly)
    }
    .tint(.red)
  }
}

extension HuntListView {
  // MARK: - ToolbarItems
  @ToolbarContentBuilder
  private func toolbarContent() -> some ToolbarContent {
    ToolbarItem(placement: .navigationBarTrailing) {
      Button(iconName: "plus") { newHuntViewIsShown.toggle() }
        .accessibilityLabel(L10n.A11yLabel.createHunt)
    }
  }

  private var noHuntsPlaceholder: some View {
    VStack(spacing: 30) {
      Text(L10n.HuntListView.listPlaceholderText)
        .multilineTextAlignment(.center)
        .font(.system(.headline, design: .rounded))
      Button(L10n.HuntListView.listPlaceholderButtonTitle) {
        newHuntViewIsShown.toggle()
      }
      .foregroundColor(Color(uiColor: .systemBackground))
      .buttonStyle(.borderedProminent)
      .controlSize(.regular)
    }
    .padding(.horizontal, 50)
  }
}
