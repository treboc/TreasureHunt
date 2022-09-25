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
        .overlay {
          mapOverlay
        }
        .toolbar(content: toolbarContent)
        .navigationTitle(stationsStore.currentStation?.name ?? "")
    }
    .sheet(isPresented: $viewModel.sheetIsShowing, content: viewModel.sheetContent)
    .onChange(of: locationProvider.reachedStation) { hasReachedStation in
      guard hasReachedStation else { return }
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
  private var nextStationButton: some View {
    Button("Nächste Station") {
      nextStation()
    }
    .buttonStyle(.borderedProminent)
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

  private var mapOverlay: some View {
    VStack(spacing: 10) {
      DirectionDistanceView(angle: locationProvider.angle, distance: locationProvider.distance)

      Spacer()

      nextStationButton

      Text("Karte?")
        .padding(.vertical, 5)
        .padding(.horizontal, 10)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 4))
        .pressAction(onPress: showMap, onRelease: hideMap)
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
    .padding()
  }

  @ToolbarContentBuilder
  func toolbarContent() -> some ToolbarContent {
    ToolbarItem(placement: .navigationBarTrailing) {
      Button(action: {
        viewModel.sheetState = .newStation
      }) {
        Image(systemName: "plus")
          .padding()
      }
    }

    ToolbarItem(placement: .navigationBarLeading) {
      Button(action: {
        viewModel.sheetState = .stationsList
      }, label: {
        Image(systemName: "list.dash")
          .padding()
      })
    }
  }


  private func showMap() {
    viewModel.mapIsHidden = false
  }

  private func hideMap() {
    viewModel.mapIsHidden = true
  }
}
