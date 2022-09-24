//  Created by Dominik Hauser on 08.09.22.
//  
//

import SwiftUI
import CoreLocation
import MapKit

struct ContentView: View {

  @EnvironmentObject private var locationProvider: LocationProvider
  @StateObject var stationsStore = StationsStore()
  @State var name: String = ""
  @State var showInput = false
  @State var showList = false
  @State private var userTrackingMode: MapUserTrackingMode = .follow

  var body: some View {
    NavigationView {
      ZStack {
        Map(coordinateRegion: $locationProvider.region, showsUserLocation: true, userTrackingMode: $userTrackingMode)
          .opacity(0.5)
          .edgesIgnoringSafeArea(.all)

        VStack {
          Spacer()

          DirectionDistance(angle: locationProvider.angle, error: nil, distance: locationProvider.distance)

          Spacer()

          Button("Nächste Station") {
            if let station = stationsStore.next() {
              name = station.name

              let coordinate = station.coordinate
              locationProvider.nextLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            }
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
      .navigationTitle(name)
      .fullScreenCover(isPresented: $showInput, content: {
        if let location = locationProvider.location {
          InputView(location: location, stationsStore: stationsStore)
//        } else {
//          EmptyView()
        }
      })
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
