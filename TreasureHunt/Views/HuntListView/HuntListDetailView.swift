//
//  HuntListDetailView.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 04.10.22.
//

import SwiftUI
import MapKit

struct HuntListDetailView: View {
  @State private var huntIsStarted: Bool = false
  @State private var region: MKCoordinateRegion
  let hunt: Hunt
  var stations: [Station] {
    return StationsStore.loadHuntStations(hunt: hunt)
  }

  init(hunt: Hunt) {
    self.hunt = hunt
    let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    let region = MKCoordinateRegion(center: hunt.centerLocation, span: span)
    _region = State(initialValue: region)
  }

  var body: some View {
    ZStack(alignment: .bottom) {
      Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: stations) {
        MapMarker(coordinate: $0.location.coordinate)
      }
      .ignoresSafeArea(.container)

      Button("Jagd starten") {
        huntIsStarted = true
      }
      .shadow(radius: 5)
      .foregroundColor(Color(uiColor: .systemBackground))
      .buttonStyle(.borderedProminent)
      .controlSize(.large)
      .padding(.bottom, 50)

    }
    .toolbar(.hidden, for: .tabBar)
    .navigationTitle(hunt.name)
    .roundedNavigationTitle()
    .fullScreenCover(isPresented: $huntIsStarted) {
      HuntView(hunt: hunt)
    }
  }
}

struct HuntListDetailView_Previews: PreviewProvider {
  static let huntsStore = HuntsStore()

  static var previews: some View {
    HuntListDetailView(hunt: huntsStore.allHunts.first!)
  }
}
