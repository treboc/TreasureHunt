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
  @Published var questionIsShown = false
  @Published var userTrackingMode: MapUserTrackingMode = .follow
}

struct MainView: View {
  @EnvironmentObject private var locationProvider: LocationProvider
  @EnvironmentObject private var stationsStore: StationsStore
  @StateObject private var viewModel = MainViewModel()

  var body: some View {
    NavigationView {
//      Map(coordinateRegion: $viewModel.region, showsUserLocation: true, userTrackingMode: $viewModel.userTrackingMode)
////        .opacity(locationProvider.distance < (stationsStore.currentStation?.triggerDistance ?? 5) * 2 ? 1.0 : 0.0)
//        .edgesIgnoringSafeArea(.all)
//        .overlay {
          mapOverlay
//        }
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
    .sheet(isPresented: $viewModel.questionIsShown) {
      nextStation()
    } content: {
      if let station = stationsStore.currentStation {
        QuestionView(station: station)
      } else {
        Text("Foo")
      }
    }
    .onChange(of: locationProvider.reachedStation) { newValue in
      guard newValue else {
        return
      }
      if let station = stationsStore.currentStation,
          false == station.question.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
        viewModel.questionIsShown = true
      } else {
        nextStation()
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
