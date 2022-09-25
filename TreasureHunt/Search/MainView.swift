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
  @Published var mapOpacity = 0.0
}

struct MainView: View {
  @EnvironmentObject private var locationProvider: LocationProvider
  @EnvironmentObject private var stationsStore: StationsStore
  @StateObject private var viewModel = MainViewModel()

  var body: some View {
    NavigationView {
//      let g = DragGesture(minimumDistance: 0, coordinateSpace: .local).onChanged({ _ in
//        viewModel.mapOpacity = 1.0
//      }).onEnded({ _ in
//        viewModel.mapOpacity = 0.0
//      })
      Map(coordinateRegion: $viewModel.region, showsUserLocation: true, userTrackingMode: $viewModel.userTrackingMode)
        .opacity(viewModel.mapOpacity)
        .edgesIgnoringSafeArea(.all)
        .overlay {
          mapOverlay
        }
        .toolbar(content: toolbarContent)
        .navigationTitle(stationsStore.currentStation?.name ?? "")
//        .gesture(g)
    }
    .fullScreenCover(isPresented: $viewModel.newStationViewIsShown) {
      if let station = stationsStore.stations.last {
        AddNewStationView(location: CLLocation(latitude: station.coordinate.latitude, longitude: station.coordinate.longitude))
      } else if let location = locationProvider.location {
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
    VStack(spacing: 10) {
      DirectionDistance(angle: $locationProvider.angle, distance: $locationProvider.distance)

      Spacer()

      nextStationButton

//      Button("Center") {
//        viewModel.userTrackingMode = .follow
//      }
//      .buttonStyle(.borderedProminent)

      HStack {

        Spacer()

        Text("Karte?")
          .gesture(
            DragGesture(minimumDistance: 0, coordinateSpace: .local).onChanged({ foo in
              viewModel.mapOpacity = 1.0
              viewModel.userTrackingMode = .follow
            }).onEnded({ _ in
              viewModel.mapOpacity = 0.0
            })
          )
          .padding()
      }
    }
    .padding()
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
