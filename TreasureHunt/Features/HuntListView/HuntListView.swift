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
              HuntListRowNavLink(hunt: hunt)
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
  private var noHuntsPlaceholder: some View {
    VStack {
      NavigationLink(destination: AddHuntView.init) {
        Text(L10n.HuntListView.listPlaceholderButtonTitle)
          .fontWeight(.semibold)
          .frame(maxWidth: .infinity)
          .foregroundColor(Color(uiColor: .systemBackground))
      }
      .buttonStyle(.borderedProminent)
      .controlSize(.large)
      .padding([.top, .horizontal])

      Text(L10n.HuntListView.listPlaceholderText)
        .multilineTextAlignment(.center)
        .font(.system(.footnote, design: .rounded))
        .italic()
        .foregroundColor(.secondary)
        .padding(.horizontal, 50)

      Spacer()
    }
  }

  struct HuntListRowNavLink: View {
    let hunt: Hunt

    var body: some View {
      HuntListRowView(hunt: hunt)
        .overlay(
          NavigationLink(
            destination: { HuntListDetailView(hunt: hunt) },
            label: { EmptyView() }
          ).opacity(0)
        )

    }
  }
}
