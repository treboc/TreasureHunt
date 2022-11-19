//
//  HuntListDetailView.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 04.10.22.
//

import SwiftUI
import MapKit
import RealmSwift

struct HuntListDetailView: View {
  @EnvironmentObject private var locationProvider: LocationProvider

  @State private var locationToEdit: THLocation? = nil
  @State private var huntToEdit: Hunt?
  @State private var huntIsStarted: Bool = false

  let hunt: Hunt

  private var huntHasStations: Bool {
    !hunt.stations.isEmpty
  }

  var body: some View {
    Group {
      if huntIsStarted {
        HuntView(hunt: hunt)
          .toolbar(.hidden, for: .tabBar, .navigationBar)
          .transition(.move(edge: .trailing))
      } else {
        if huntHasStations {
          huntDetails
        } else {
          emptyListPlaceholder
        }
      }
    }
    .navigationTitle(hunt.name)
    .toolbar {
      ToolbarItemGroup(placement: .navigationBarTrailing) {
        Button(iconName: "square.and.pencil") {
          huntToEdit = hunt
        }
      }
    }
    .toolbar(.hidden, for: .tabBar)
    .sheet(item: $locationToEdit) {
      AddLocationView(location: $0)
    }
    .sheet(item: $huntToEdit) { hunt in
      AddHuntView(huntToEdit: hunt)
    }
  }
}

extension HuntListDetailView {
  private var emptyListPlaceholder: some View {
    VStack(alignment: .center, spacing: 20) {
      Text(L10n.HuntListDetailView.noStationsPlaceholderText)
        .font(.system(.body, design: .rounded))
        .foregroundColor(.secondary)
      Button(L10n.HuntListDetailView.noStationsEditHuntButtonTitle) {
        huntToEdit = hunt
      }
      .buttonStyle(.borderedProminent)
      .controlSize(.regular)
      .foregroundStyle(.primary)
    }
    .padding()
    .background(
      RoundedRectangle(cornerRadius: 16)
        .fill(.ultraThinMaterial)
        .shadow(radius: 8)
    )
    .padding()
  }

  private var huntDetails: some View {
    ScrollView {
      title
      ForEach(0..<hunt.stations.count, id: \.self) { index in
        HuntListDetailRowView(station: hunt.stations[index], position: index + 1)
          .listRowSeparator(.hidden)
          .listRowInsets(.init(top: 5, leading: 0, bottom: 5, trailing: 0))
          .onTapGesture {
//            stationToEdit = hunt.stations[index].location
          }
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
    Button(L10n.HuntListDetailView.startHuntButtonTitle) {
      withAnimation {
        huntIsStarted = true
      }
    }
    .shadow(radius: 5)
    .foregroundColor(Color(uiColor: .systemBackground))
    .buttonStyle(.borderedProminent)
    .controlSize(.large)
    .padding(.bottom, 50)
    .disabled(huntHasStations == false)
  }
}

