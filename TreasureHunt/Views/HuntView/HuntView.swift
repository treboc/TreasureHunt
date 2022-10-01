//  Created by Dominik Hauser on 08.09.22.
//  
//

import SwiftUI
import CoreLocation
import MapKit

struct HuntView: View {
  @Environment(\.dismiss) private var dismiss
  @StateObject private var huntManager: HuntManager
  @State private var warningRead: Bool = false
  @State private var endSessionAlertIsShown: Bool = false

  init(stations: [Station]) {
    _huntManager = StateObject(wrappedValue: HuntManager(stations))
  }

  var body: some View {
    NavigationView {
      ZStack {
        Map(coordinateRegion: $huntManager.region,
            showsUserLocation: true,
            userTrackingMode: .constant(.follow),
            annotationItems: huntManager.stations,
            annotationContent: { station in
          MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: station.coordinate.latitude, longitude: station.coordinate.longitude)) {
            StationAnnotationView(station: station)
              .shadow(radius: 10)
          }
        })
        .allowsHitTesting(false)
        .opacity(huntManager.isNearCurrentStation ? 1.0 : 0.0)

        arrowOverlay()

        showMapButton()
        endHuntButton()
          .alert("Bist du sicher?", isPresented: $endSessionAlertIsShown) {
            Button("Abbrechen", role: .cancel) {}
            Button("Ja, beenden", role: .destructive) { dismiss.callAsFunction() }
          } message: {
            Text("Damit wird die Suche beendet, dein Fortschritt ist nicht gespeichert.")
          }


        nextStationButton()

        if warningRead == false {
          TrafficWarningView(warningRead: $warningRead)
            .transition(.opacity.combined(with: .scale))
            .zIndex(2)
        }
      }
      .animation(.default, value: huntManager.isNearCurrentStation)
      .ignoresSafeArea()
      .navigationBarHidden(true)
      .sheet(isPresented: $huntManager.questionSheetIsShown, onDismiss: huntManager.setNextStation) {
        if let station = huntManager.currentStation {
          QuestionView(station: station)
        }
      }
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button("Beenden", action: dismiss.callAsFunction)
        }
      }
    }
    .onAppear(perform: applyIdleDimmingSetting)
    .onDisappear(perform: disableIdleDimming)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    HuntView(stations: [])
  }
}

extension HuntView {
  @ViewBuilder
  private func arrowOverlay() -> some View {
  private func endHuntButton() -> some View {
    Image(systemName: "xmark")
      .resizable()
      .padding(10)
      .background(.thinMaterial, in: Circle())
      .frame(width: 44, height: 44, alignment: .center)
      .foregroundColor(.primaryAccentColor)
      .onTapGesture(perform: endHuntButtonTapped)
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
      .padding([.bottom, .leading], 20)
  }

    if let _ = huntManager.currentStation,
      DirectionDistanceView(angle: huntManager.angle, distance: huntManager.distance)
       huntManager.isNearCurrentStation == false {
        .shadow(radius: 5)
    }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
  }

  @ViewBuilder
  private func showMapButton() -> some View {
    if huntManager.isNearCurrentStation == false {
      Image(systemName: "map")
        .resizable()
        .padding(10)
        .background(.thinMaterial, in: Circle())
        .frame(width: 44, height: 44, alignment: .center)
        .foregroundColor(.primaryAccentColor)
        .pressAction(onPress: showMap, onRelease: hideMap)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        .padding([.bottom, .trailing], 20)
    }
  }

  @ViewBuilder
  private func nextStationButton() -> some View {
    if huntManager.distance < 50 {
      Button("Nächste Station") {
        huntManager.setNextStation()
      }
      .buttonStyle(.borderedProminent)
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
      .padding(.bottom, 50)
    }
  }

  private func showMap() {
    huntManager.isNearCurrentStation = false
  }

  private func hideMap() {
    huntManager.isNearCurrentStation = true
  }

  private func applyIdleDimmingSetting() {
    UIApplication.shared.isIdleTimerDisabled = huntManager.idleDimmingDisabled
  }

  private func disableIdleDimming() {
    UIApplication.shared.isIdleTimerDisabled = false
  }

  private func endHuntButtonTapped() {
    endSessionAlertIsShown = true
  }
}
