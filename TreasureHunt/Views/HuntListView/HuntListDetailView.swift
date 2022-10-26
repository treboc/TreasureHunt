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
  @State private var huntToEdit: Hunt?
  @State private var huntIsStarted: Bool = false

  let hunt: Hunt

  private var canStartHunt: Bool {
    !hunt.stations.isEmpty
  }

  var body: some View {
    VStack {
      title

      if canStartHunt {
        List(hunt.stations) { station in
          HuntListDetailRowView(station: station)
            .listRowSeparator(.hidden)
            .listRowInsets(.init(top: 5, leading: 0, bottom: 5, trailing: 0))
        }
        .listStyle(.plain)
        .safeAreaInset(edge: .bottom, spacing: 20) {
          startHuntButton
        }
      } else {
        HStack {
          Text("Diese Jagd hat keine Stationen, bitte füge zuerst mindestens eine hinzu.")
            .font(.caption)
            .foregroundColor(.red)
          Button("Bearbeiten") {
            //
          }
          .buttonStyle(.bordered)
          .controlSize(.regular)
        }
      }
    }
    .navigationBarTitleDisplayMode(.inline)
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    .toolbar(.hidden, for: .tabBar)
    .fullScreenCover(isPresented: $huntIsStarted) {
      HuntView(hunt: hunt)
    }
  }
}

struct HuntListDetailView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      NavigationView {
        HuntListDetailView(hunt: Hunt.hunt)
      }

      HuntListDetailView.HuntListDetailRowView(station: Station.station)
        .padding()
        .previewLayout(.sizeThatFits)
    }
  }
}

extension HuntListDetailView {
  private var title: some View {
    HStack(alignment: .top) {
      VStack(alignment: .leading, spacing: 0) {
        Text("Name der Jagd".uppercased())
          .font(.system(.caption, design: .rounded, weight: .regular))
          .foregroundColor(.secondary)

        Text(hunt.name)
          .font(.system(.largeTitle, design: .rounded, weight: .heavy))
      }
      .padding(.horizontal)
      .frame(maxWidth: .infinity, alignment: .leading)

      VStack(alignment: .trailing, spacing: 0) {
        Text("Erstellt am".uppercased())
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
    Button("Jagd starten") {
      huntIsStarted = true
    }
    .shadow(radius: 5)
    .foregroundColor(Color(uiColor: .systemBackground))
    .buttonStyle(.borderedProminent)
    .controlSize(.large)
    .padding(.bottom, 50)
    .disabled(canStartHunt == false)
  }
}

extension HuntListDetailView {
  struct HuntListDetailRowView: View {
    @EnvironmentObject private var locationProvider: LocationProvider
    let station: Station

    func distanceToStation() -> String {
      if let distance = locationProvider.distanceTo(station.location) {
        return distance.asDistance()
      } else {
        return "Distanz N/A"
      }
    }

    var body: some View {
      VStack(alignment: .leading, spacing: 10) {
        // title
        VStack(alignment: .leading, spacing: 2) {
          Text("Name der Station".localizedUppercase)
            .font(.system(.caption2, design: .rounded))
            .foregroundColor(.secondary)

          Text(station.name)
            .font(.system(.title2, design: .rounded, weight: .semibold))
        }

        Divider()

        // distance to station
        VStack(alignment: .leading, spacing: 2) {
          Text("Distanz von hier:".localizedUppercase)
            .font(.system(.caption2, design: .rounded))
            .foregroundColor(.secondary)

          Text(distanceToStation())
            .font(.system(.headline, design: .rounded))
        }

        // question & answer
        if station.question.isEmpty == false {
          VStack(alignment: .leading, spacing: 2) {
            Text("Aufgabe".localizedUppercase)
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
      .padding()
      .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .circular))
      .padding(.horizontal)
    }
  }
}

