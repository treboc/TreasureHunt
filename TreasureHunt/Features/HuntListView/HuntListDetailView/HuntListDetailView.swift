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
      .toolbar { editHuntNavigationLink }
      .toolbar(.hidden, for: .tabBar)
  }
}

extension HuntListDetailView {
  private var huntDetails: some View {
    ScrollView {
      creationDateView

      if hunt.hasIntroduction {
        IntroductionView(introduction: hunt.unwrappedIntroduction)
      }
      
      StationsList(hunt: hunt)
      
      if hunt.hasOutro {
        OutroView(outro: hunt.unwrappedOutro,
                  outroLocation: hunt.outroLocation)
      }
    }
    .safeAreaInset(edge: .bottom, spacing: 20) {
      startHuntButton
    }
    .transition(.opacity)
  }

  @ViewBuilder
  private var creationDateView: some View {
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
    .disabled(!isValidHunt())
  }

  private var editHuntNavigationLink: some View {
    NavigationLink {
      AddHuntView(locationProvider: locationProvider, huntToEdit: hunt)
    } label: {
      Image(systemName: "square.and.pencil")
    }
    .accessibilityLabel(Text("Edit this hunt"))
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
