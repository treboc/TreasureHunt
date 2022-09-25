//  Created by Dominik Hauser on 08.09.22.
//  
//

import SwiftUI
import CoreLocation
import MapKit

struct MainView: View {
  @EnvironmentObject private var locationProvider: LocationProvider
  @EnvironmentObject private var stationsStore: StationsStore
  @StateObject private var viewModel = MainViewModel()

  var body: some View {
    NavigationView {
      Map(coordinateRegion: $locationProvider.region, showsUserLocation: true, userTrackingMode: .constant(.follow))
        .opacity(viewModel.mapIsHidden ? 0.0 : 1.0)
        .animation(.easeInOut, value: viewModel.mapIsHidden)
        .edgesIgnoringSafeArea(.all)
        .overlay(alignment: .center, content: arrowOverlay)
        .overlay(alignment: .bottomTrailing, content: showMapButton)
        .overlay(alignment: .bottom, content: nextStationButton)
        .toolbar(content: toolbarContent)
        .navigationTitle(stationsStore.currentStation?.name ?? "")
    }
    .sheet(isPresented: $viewModel.sheetIsShowing, content: viewModel.sheetContent)
    .onChange(of: locationProvider.reachedStation) { hasReachedStation in
      if let station = stationsStore.currentStation,
         station.question.isEmpty == false {
        viewModel.sheetState = .question(station)
      } else {
        // show alert if next station should be shown, because there's no question
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    MainView()
  }
}

extension MainView {
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
      if stationsStore.stations.isEmpty == false {
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

  // MARK: - ToolbarItems
  @ToolbarContentBuilder
  func toolbarContent() -> some ToolbarContent {
    ToolbarItem(placement: .navigationBarTrailing) {
      Button {
        viewModel.showSheet(.newStation)
      } label: {
        Image(systemName: "plus")
      }
    }

    ToolbarItem(placement: .navigationBarLeading) {
      Button {
        viewModel.showSheet(.stationsList)
      } label: {
        Image(systemName: "list.dash")
      }
    }
  }
}
