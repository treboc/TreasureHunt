//
//  HuntListView.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 03.10.22.
//

import SwiftUI

struct HuntListView: View {
  @EnvironmentObject private var locationProvider: LocationProvider
  @State private var huntDeletionAlertIsShown: Bool = false
  @State private var huntToDelete: THHunt? = nil

  @FetchRequest(sortDescriptors: [])
  private var hunts: FetchedResults<THHunt>

  var body: some View {
    NavigationStack {
      ZStack {
        if hunts.isEmpty {
          noHuntsPlaceholder
        } else {
          List {
            ForEach(hunts, id: \.objectID) { hunt in
              LazyView(
                HuntListRowView(hunt: hunt)
                  .invisibleNavigationLink {
                    HuntListDetailView(hunt: hunt)
                  }
              )
              .swipeActions {
                swipeToDelete(hunt)
              }
            }

            createNewHuntButton
          }
          .listStyle(.plain)
        }
      }
      .alert(L10n.Alert.DeleteHunt.title, isPresented: $huntDeletionAlertIsShown, actions: {
        Button(L10n.BtnTitle.cancel, role: .cancel) {}
        Button(L10n.BtnTitle.iAmSure, role: .destructive) {
          if let huntToDelete {
            withAnimation {
              THHuntModelService.delete(huntToDelete)
            }
          }
        }
      }, message: {
        Text(L10n.Alert.DeleteHunt.message)
      })
      .animation(.default, value: huntDeletionAlertIsShown)
      .navigationTitle(L10n.SimpleConstants.hunts)
      .toolbar {
        Button("Delete all") {
          for hunt in hunts {
            PersistenceController.shared.context.delete(hunt)
          }
          try? PersistenceController.shared.context.save()
        }
      }
    }
  }
}

struct HuntListView_Previews: PreviewProvider {
  static var previews: some View {
    HuntListView()
      .environment(\.managedObjectContext, PersistenceController.preview.context)
  }
}

extension HuntListView {
  private func swipeToDelete(_ hunt: THHunt) -> some View {
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
      NavigationLink {
        LazyView(AddHuntView(locationProvider: locationProvider))
      } label: {
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

  private var createNewHuntButton: some View {
    Text(L10n.HuntListView.listPlaceholderButtonTitle)
      .fontWeight(.semibold)
      .frame(maxWidth: .infinity)
      .foregroundColor(Color(uiColor: .systemBackground))
      .padding()
      .background(
        RoundedRectangle(cornerRadius: Constants.cornerRadius)
          .fill(Color.accentColor)
      )
      .listRowInsets(.init(top: 10, leading: 10, bottom: 10, trailing: 10))
      .listRowSeparator(.hidden)
      .listRowBackground(Color.clear)
      .invisibleNavigationLink {
        LazyView(AddHuntView(locationProvider: locationProvider))
      }
  }
}
