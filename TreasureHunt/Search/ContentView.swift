//  Created by Dominik Hauser on 08.09.22.
//  
//

import SwiftUI
import CoreLocation
import MapKit

struct ContentView: View {
  @EnvironmentObject private var locationProvider: LocationProvider
  @EnvironmentObject private var stationsStore: StationsStore
  @State var showInput = false
  @State var showList = false
  @State private var userTrackingMode: MapUserTrackingMode = .follow

  var body: some View {
    NavigationView {
      ZStack {
        Map(coordinateRegion: $locationProvider.region, showsUserLocation: true)
          .opacity(0.5)
          .edgesIgnoringSafeArea(.all)

        VStack {
          Spacer()

          DirectionDistance(angle: $locationProvider.angle, distance: $locationProvider.distance)

          Spacer()

          Button("Nächste Station") {
            stationsStore.setNextStation()
            if let station = stationsStore.currentStation {
              let location: CLLocation = .init(latitude: station.coordinate.latitude,
                                                           longitude: station.coordinate.longitude)
              locationProvider.nextLocation = location
            }
          }
          .buttonStyle(.borderedProminent)

          Button("Center") {
            userTrackingMode = .follow
          }
          .buttonStyle(.borderedProminent)
        }
      }
      .navigationBarItems(
        leading:
          Button(action: {
            showList.toggle()
          }, label: {
            Image(systemName: "list.dash")
              .padding()
          }),
        trailing:
          Button(action: {
            showInput.toggle()
          }) {
            Image(systemName: "plus")
              .padding()
          })
      .navigationTitle(stationsStore.currentStation?.name ?? "")
      .fullScreenCover(isPresented: $showInput) {
        if let location = locationProvider.location {
          InputView(location: location)
        }
      }
      .sheet(isPresented: $showList) {
        StationsListView(stationStore: stationsStore)
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
