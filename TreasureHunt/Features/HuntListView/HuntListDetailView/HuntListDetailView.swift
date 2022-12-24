//
//  HuntListDetailView.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 04.10.22.
//

import SwiftUI
import MapKit

struct HuntListDetailView: View {
  @EnvironmentObject private var locationProvider: LocationProvider
  @ObservedObject var hunt: THHunt

  var body: some View {
    huntDetails
      .gradientBackground()
      .navigationTitle(hunt.unwrappedTitle)
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
      // CreationDate
      creationDateRow

      if hunt.hasIntroduction {
        // Introduction
        IntroductionView(introduction: hunt.unwrappedIntroduction)
      }

      // StationsList
      StationsList(hunt: hunt)

      if hunt.hasOutline {
        // Outline
        OutlineView(outline: hunt.unwrappedOutline,
                    outlineLocation: hunt.outlineLocation)
      }
    }
    .safeAreaInset(edge: .bottom, spacing: 20) {
      startHuntButton
    }
    .transition(.opacity)
  }

  @ViewBuilder
  private var creationDateRow: some View {
    if let createdAt = hunt.createdAt {
      VStack(alignment: .leading, spacing: 0) {
        Text(L10n.HuntListDetailView.createdAt.uppercased())
          .font(.system(.caption, design: .rounded, weight: .regular))
          .foregroundColor(.secondary)

        Text("\(createdAt.formatted(date: .abbreviated, time: .shortened))")
          .font(.system(.subheadline, design: .rounded, weight: .heavy))
      }
      .padding(.horizontal)
      .frame(maxWidth: .infinity, alignment: .leading)
    }
  }

  private var startHuntButton: some View {
    NavigationLink(L10n.HuntListDetailView.startHuntButtonTitle) {
      LazyView(HuntView(hunt: hunt))
        .toolbar(.hidden, for: .tabBar, .navigationBar)
    }
    .shadow(radius: Constants.Shadows.secondLevel)
    .foregroundColor(.label)
    .buttonStyle(.borderedProminent)
    .controlSize(.large)
    .padding(.bottom, 50)
    .disabled(!isValidHunt())
  }
}

extension HuntListDetailView {
  func isValidHunt() -> Bool {
    let isValid = !hunt.stationsArray
      .map(\.location)
      .contains(where: { $0 == nil })
    return isValid
  }
}
