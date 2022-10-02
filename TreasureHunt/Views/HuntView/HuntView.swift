//  Created by Dominik Hauser on 08.09.22.
//  
//

import SwiftUI
import CoreLocation
import MapKit

struct HuntView: View {
  @Environment(\.dismiss) private var dismiss
  @StateObject private var huntManager: HuntManager
  @StateObject private var vm = HuntViewModel()

  init(stations: [Station]) {
    _huntManager = StateObject(wrappedValue: HuntManager(stations))
  }

  private var blurRadius: CGFloat {
    if huntManager.isNearCurrentStation || vm.mapIsShown {
      return 0
    }
    return 20
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
        .ignoresSafeArea()
        .allowsHitTesting(false)
        .blur(radius: blurRadius)
        .animation(.default, value: blurRadius)

        arrowOverlay()
        showMapButton()
        endHuntButton()

        nextStationButton()

        if vm.warningRead == false {
          TrafficWarningView(warningRead: $vm.warningRead)
            .transition(.opacity.combined(with: .scale))
            .zIndex(2)
        }
      }
      .animation(.default, value: huntManager.isNearCurrentStation)
      .navigationBarHidden(true)
      .alert("Bist du sicher?", isPresented: $vm.endSessionAlertIsShown) {
        Button("Abbrechen", role: .cancel) {}
        Button("Ja, beenden", role: .destructive) { dismiss.callAsFunction() }
      } message: {
        Text("Damit wird die Suche beendet, dein Fortschritt ist nicht gespeichert.")
      }
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
    .onAppear(perform: vm.applyIdleDimmingSetting)
    .onDisappear(perform: vm.disableIdleDimming)
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
      DirectionDistanceView(huntManager: huntManager)
        .shadow(radius: 5)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
  }

  @ViewBuilder
  private func endHuntButton() -> some View {
    if huntManager.currentStationIsLastStation && huntManager.isNearCurrentStation {
      Button("Suche Beenden") {
        vm.endHuntButtonTapped()
      }
      .buttonStyle(.borderedProminent)
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
      .padding(.bottom, 50)
    } else {
      Image(systemName: "xmark")
        .resizable()
        .padding(10)
        .background(.thinMaterial, in: Circle())
        .frame(width: 44, height: 44, alignment: .center)
        .foregroundColor(.primaryAccentColor)
        .onTapGesture(perform: vm.endHuntButtonTapped)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
        .padding([.bottom, .leading], 20)
    }
  }

  @ViewBuilder
  private func showMapButton() -> some View {

      Image(systemName: "map")
        .resizable()
        .padding(10)
        .background(.thinMaterial, in: Circle())
        .frame(width: 44, height: 44, alignment: .center)
        .foregroundColor(.primaryAccentColor)
        .pressAction(onPress: vm.showMap, onRelease: vm.hideMap)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        .padding([.bottom, .trailing], 20)
  }

  @ViewBuilder
  private func nextStationButton() -> some View {
    if huntManager.isNearCurrentStation && huntManager.currentStationIsLastStation == false {
      Button("Nächste Station") {
        huntManager.nextStationButtonTapped()
      }
      .buttonStyle(.borderedProminent)
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
      .padding(.bottom, 50)
    }
  }


}
