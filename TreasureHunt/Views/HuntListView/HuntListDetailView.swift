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

  @State private var stationToEdit: Station? = nil
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
    .sheet(item: $stationToEdit) { station in
      AddStationView(stationToEdit: station)
    }
    .sheet(item: $huntToEdit) { hunt in
      AddHuntView(huntToEdit: hunt)
    }
  }
}

extension HuntListDetailView {
  private var title: some View {
    HStack(alignment: .top) {
      VStack(alignment: .leading, spacing: 0) {
        Text(L10n.HuntListDetailView.huntName.uppercased())
          .font(.system(.caption, design: .rounded, weight: .regular))
          .foregroundColor(.secondary)
      }
      .padding(.horizontal)
      .frame(maxWidth: .infinity, alignment: .leading)

      VStack(alignment: .trailing, spacing: 0) {
        Text(L10n.HuntListDetailView.createdAt.uppercased())
          .font(.system(.caption, design: .rounded, weight: .regular))
          .foregroundColor(.secondary)

        Text("\(hunt.createdAt.formatted(date: .abbreviated, time: .shortened))")
          .font(.system(.subheadline, design: .rounded, weight: .heavy))
      }
      .padding(.horizontal)
      .frame(maxWidth: .infinity, alignment: .trailing)
    }
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

  private var emptyListPlaceholder: some View {
    VStack(alignment: .center, spacing: 20) {
      Text("Diese Jagd hat keine Stationen, bitte füge zuerst mindestens eine hinzu.")
        .font(.system(.body, design: .rounded))
        .foregroundColor(.red)
      Button(L10n.HuntListDetailView.noStationsEditHuntButtonTitle) {
        huntToEdit = hunt
      }
      .buttonStyle(.bordered)
      .controlSize(.regular)
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
            stationToEdit = hunt.stations[index]
          }
      }
      .listStyle(.plain)
    }
    .safeAreaInset(edge: .bottom, spacing: 20) {
      startHuntButton
    }
    .transition(.opacity)
  }
}

extension HuntListDetailView {
  struct HuntListDetailRowView: View {
    @EnvironmentObject private var locationProvider: LocationProvider
    let station: Station
    let position: Int

    func distanceToStation() -> String {
      if let distance = locationProvider.distanceTo(station.location) {
        return distance.asDistance()
      } else {
        return "N/A"
      }
    }

    var body: some View {
      VStack(alignment: .leading, spacing: 10) {
        // title
        VStack(alignment: .leading, spacing: 2) {
          Text(L10n.HuntListDetailRowView.stationName.localizedUppercase)
            .font(.system(.caption2, design: .rounded))
            .foregroundColor(.secondary)

          Text(station.name)
            .font(.system(.title2, design: .rounded, weight: .semibold))
        }

        Divider()

        // distance to station
        VStack(alignment: .leading, spacing: 2) {
          Text(L10n.HuntListDetailRowView.distanceFromHere.localizedUppercase)
            .font(.system(.caption2, design: .rounded))
            .foregroundColor(.secondary)

          Text(distanceToStation())
            .font(.system(.headline, design: .rounded))
        }

        // question & answer
        if station.question.isEmpty == false {
          VStack(alignment: .leading, spacing: 2) {
            Text(L10n.HuntListDetailRowView.question.localizedUppercase)
              .font(.system(.caption2, design: .rounded))
              .foregroundColor(.secondary)

            Text(station.question)
              .font(.system(.headline, design: .rounded))
              .lineLimit(0)
              .multilineTextAlignment(.leading)
          }
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .overlay(alignment: .topTrailing) {
        Image(systemName: "\(position).circle.fill")
          .font(.title)
          .foregroundStyle(Color.accentColor)
      }
      .padding()
      .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .circular))
      .padding(.horizontal)
    }
  }
}

