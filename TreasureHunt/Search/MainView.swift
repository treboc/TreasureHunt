//  Created by Dominik Hauser on 08.09.22.
//  
//

import SwiftUI
import CoreLocation
import MapKit

final class MainViewModel: ObservableObject {
  @Published var region = MKCoordinateRegion(center: .init(), latitudinalMeters: 1000, longitudinalMeters: 1000)
  @Published var newStationViewIsShown = false
  @Published var stationsListIsShown = false
  @Published var userTrackingMode: MapUserTrackingMode = .follow
}

struct MainView: View {
  @EnvironmentObject private var locationProvider: LocationProvider
  @EnvironmentObject private var stationsStore: StationsStore
  @StateObject private var viewModel = MainViewModel()

  var body: some View {
    NavigationView {
      Map(coordinateRegion: $viewModel.region, showsUserLocation: true, userTrackingMode: $viewModel.userTrackingMode)
        .opacity(0.5)
        .edgesIgnoringSafeArea(.all)
        .overlay {
          mapOverlay
        }
        .toolbar(content: toolbarContent)
        .navigationTitle(stationsStore.currentStation?.name ?? "")
    }
    .fullScreenCover(isPresented: $viewModel.newStationViewIsShown) {
      if let location = locationProvider.location {
        AddNewStationView(location: location)
      }
    }
    .sheet(isPresented: $viewModel.stationsListIsShown) {
      StationsListView(stationStore: stationsStore)
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
      stationsStore.setNextStation()
      if let station = stationsStore.currentStation {
        let location: CLLocation = .init(latitude: station.coordinate.latitude,
                                         longitude: station.coordinate.longitude)
        locationProvider.nextLocation = location
      }
    }
    .buttonStyle(.borderedProminent)
  }

  private var mapOverlay: some View {
    VStack {
      DirectionDistance(angle: $locationProvider.angle, distance: $locationProvider.distance)

      Spacer()

      nextStationButton

      Button("Center") {
        viewModel.userTrackingMode = .follow
      }
      .buttonStyle(.borderedProminent)
    }
  }

  @ToolbarContentBuilder
  func toolbarContent() -> some ToolbarContent {
    ToolbarItem(placement: .navigationBarTrailing) {
      Button(action: {
        viewModel.newStationViewIsShown = true
      }) {
        Image(systemName: "plus")
          .padding()
      }
    }

    ToolbarItem(placement: .navigationBarLeading) {
      Button(action: {
        viewModel.stationsListIsShown = true
      }, label: {
        Image(systemName: "list.dash")
          .padding()
      })
    }
  }

}
