//  Created by Dominik Hauser on 08.09.22.
//  
//

import SwiftUI
import CoreLocation
import MapKit

struct HuntView: View {
  @EnvironmentObject private var locationProvider: LocationProvider
  @StateObject private var viewModel = HuntViewModel()
  @StateObject private var huntManager: HuntManager

  init(stations: [Station]) {
    _huntManager = StateObject(wrappedValue: HuntManager(stations))
  }

  var body: some View {
    Map(coordinateRegion: $locationProvider.region, showsUserLocation: true, userTrackingMode: .constant(.follow))
      .opacity(viewModel.mapIsHidden ? 0.0 : 1.0)
      .animation(.easeInOut, value: viewModel.mapIsHidden)
      .edgesIgnoringSafeArea(.all)
      .overlay(alignment: .center, content: arrowOverlay)
      .overlay(alignment: .bottomTrailing, content: showMapButton)
      .overlay(alignment: .bottom, content: nextStationButton)
      .navigationTitle(huntManager.currentStation?.name ?? "")
      .sheet(isPresented: $viewModel.questionSheetIsShown, onDismiss: huntManager.setNextStation) {
        if let station = huntManager.currentStation {
          QuestionView(station: station)
        }
      }
      .onChange(of: locationProvider.reachedStation) { hasReachedStation in
        if let station = huntManager.currentStation,
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
    HuntView(stations: [])
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
    huntManager.setNextStation()
    if let station = huntManager.currentStation {
      let location: CLLocation = .init(latitude: station.coordinate.latitude,
                                       longitude: station.coordinate.longitude)
      locationProvider.nextLocation = location
      locationProvider.triggerDistance = station.triggerDistance
      locationProvider.start()
    }
  }

  private func arrowOverlay() -> some View {
    VStack(spacing: 10) {
      if let _ = huntManager.currentStation {
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
