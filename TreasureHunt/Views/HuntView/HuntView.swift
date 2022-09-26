//  Created by Dominik Hauser on 08.09.22.
//  
//

import SwiftUI
import CoreLocation
import MapKit

struct HuntView: View {
  @EnvironmentObject private var locationProvider: LocationProvider
  @EnvironmentObject private var stationsStore: StationsStore
  @StateObject private var viewModel = HuntViewModel()

  var body: some View {
    NavigationView {
      Map(coordinateRegion: $locationProvider.region, showsUserLocation: true, userTrackingMode: .constant(.follow))
        .opacity(viewModel.mapIsHidden ? 0.0 : 1.0)
        .animation(.easeInOut, value: viewModel.mapIsHidden)
        .edgesIgnoringSafeArea(.all)
        .overlay(alignment: .center, content: arrowOverlay)
        .overlay(alignment: .bottomTrailing, content: showMapButton)
        .overlay(alignment: .bottom, content: nextStationButton)
        .navigationTitle(stationsStore.currentStation?.name ?? "")
    }
    .sheet(isPresented: $viewModel.questionSheetIsShown, onDismiss: nil) {
      if let station = stationsStore.currentStation {
        QuestionView(station: station)
      }
    }
    .onChange(of: locationProvider.reachedStation) { hasReachedStation in
      if let station = stationsStore.currentStation,
         station.question.isEmpty == false {
        viewModel.questionSheetIsShown = true
      } else {
        // show alert if next station should be shown, because there's no question
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    HuntView()
  }
}

extension HuntView {
  private func nextStationButton() -> some View {
    Button("Nächste Station") {
      nextStation()
    }
    .buttonStyle(.borderedProminent)
    .padding(.bottom, 50)
  }

  private func nextStation() {
    stationsStore.setNextStation()
    if let station = stationsStore.currentStation {
      let location: CLLocation = .init(latitude: station.coordinate.latitude,
                                       longitude: station.coordinate.longitude)
      locationProvider.nextLocation = location
      locationProvider.triggerDistance = station.triggerDistance
      locationProvider.start()
    }
  }

  private func arrowOverlay() -> some View {
    VStack(spacing: 10) {
      if stationsStore.allStations.isEmpty == false {
        DirectionDistanceView(angle: locationProvider.angle, distance: locationProvider.distance)
      }
    }
    .frame(maxHeight: .infinity, alignment: .top)
  }



  private func showMapButton() -> some View {
    Text("Karte?")
      .padding(.vertical, 5)
      .padding(.horizontal, 10)
      .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 4))
      .pressAction(onPress: showMap, onRelease: hideMap)
      .frame(maxWidth: .infinity, alignment: .trailing)
  }

  private func showMap() {
    viewModel.mapIsHidden = false
  }

  private func hideMap() {
    viewModel.mapIsHidden = true
  }

}
