//
//  HuntListDetailView.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 04.10.22.
//

import SwiftUI
import MapKit
import RealmSwift

struct NavigationLazyView<Content: View>: View {
  let build: () -> Content
  init(_ build: @autoclosure @escaping () -> Content) {
    self.build = build
  }
  var body: Content {
    build()
  }
}

struct HuntListDetailView: View {
  @EnvironmentObject private var locationProvider: LocationProvider
  @ObservedRealmObject var hunt: Hunt

  var body: some View {
    huntDetails
      .navigationTitle(hunt.name)
      .toolbar {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
          NavigationLink {
            AddHuntView(locationProvider: locationProvider, huntToEdit: hunt)
          } label: {
            Image(systemName: "square.and.pencil")
          }
          .accessibilityLabel(Text("Edit this hunt"))
        }
      }
      .toolbar(.hidden, for: .tabBar)
  }
}

extension HuntListDetailView {
  private var huntDetails: some View {
    ScrollView {
      title
      ForEach(0..<hunt.stations.count, id: \.self) { index in
        HuntListDetailRowView(station: hunt.stations[index], position: index + 1)
          .listRowSeparator(.hidden)
          .listRowInsets(.init(top: 5, leading: 0, bottom: 5, trailing: 0))
      }
      .listStyle(.plain)
    }
    .safeAreaInset(edge: .bottom, spacing: 20) {
      startHuntButton
    }
    .transition(.opacity)
  }

  private var title: some View {
    VStack(alignment: .leading, spacing: 0) {
      Text(L10n.HuntListDetailView.createdAt.uppercased())
        .font(.system(.caption, design: .rounded, weight: .regular))
        .foregroundColor(.secondary)

      Text("\(hunt.createdAt.formatted(date: .abbreviated, time: .shortened))")
        .font(.system(.subheadline, design: .rounded, weight: .heavy))
    }
    .padding(.horizontal)
    .frame(maxWidth: .infinity, alignment: .leading)
  }

  private var startHuntButton: some View {
    NavigationLink(L10n.HuntListDetailView.startHuntButtonTitle) {
      NavigationLazyView(HuntView(hunt: hunt))
        .toolbar(.hidden, for: .tabBar, .navigationBar)
        .transition(.move(edge: .trailing))
    }
    .shadow(radius: 5)
    .foregroundColor(Color(uiColor: .systemBackground))
    .buttonStyle(.borderedProminent)
    .controlSize(.large)
    .padding(.bottom, 50)
  }
}
