//  Created by Dominik Hauser on 08.09.22.
//  
//

import SwiftUI
import CoreLocation
import MapKit

struct HuntView: View {
  @Environment(\.dismiss) private var dismiss
  @State private var warningRead: Bool = false
  @StateObject private var huntManager: HuntManager

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
        .opacity(huntManager.mapIsHidden ? 0.0 : 1.0)
        .animation(.easeInOut, value: huntManager.mapIsHidden)

        arrowOverlay()
        showMapButton()
        nextStationButton()

//          .overlay(alignment: .bottomTrailing, content: showMapButton)
//        .overlay(alignment: .bottom, content: nextStationButton)

        if warningRead == false {
          TrafficWarningView(warningRead: $warningRead)
        }
      }
      .ignoresSafeArea()
      .navigationTitle(huntManager.currentStation?.name ?? "")
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
      .onAppear {
        UIApplication.shared.isIdleTimerDisabled = huntManager.idleDimmingDisabled
      }
      .onDisappear {
        UIApplication.shared.isIdleTimerDisabled = false
      }

    }
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
    if let _ = huntManager.currentStation {
      DirectionDistanceView(angle: $huntManager.angle, distance: $huntManager.distance)
        .shadow(radius: 5)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
  }

  private func showMapButton() -> some View {
    Text("Karte?")
      .padding(.vertical, 5)
      .padding(.horizontal, 10)
      .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 4))
      .pressAction(onPress: showMap, onRelease: hideMap)
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
      .padding([.bottom, .trailing], 40)
  }

  @ViewBuilder
  private func nextStationButton() -> some View {
    if huntManager.distance < 50 {
      Button("Nächste Station") {
        huntManager.setNextStation()
      }
      .buttonStyle(.borderedProminent)
      .padding(.bottom, 50)
    }
  }

  private func showMap() {
    huntManager.mapIsHidden = false
  }

  private func hideMap() {
    huntManager.mapIsHidden = true
  }

}
