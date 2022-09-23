//  Created by Dominik Hauser on 21.09.22.
//  
//

import SwiftUI
import MapKit

struct InputView: View {

  @Environment(\.presentationMode) var presentationMode
  @State var name: String = ""
  let location: CLLocation
  let stationsStore: StationsStore
  @State var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), latitudinalMeters: 1000, longitudinalMeters: 1000)

  init(location: CLLocation, stationsStore: StationsStore) {
    self.location = location
    self.stationsStore = stationsStore
  }

  var body: some View {
    VStack {
      ZStack {
        Map(coordinateRegion: $region)

        Image(systemName: "circle")
      }
      .frame(height: 300)

      VStack(spacing: 5) {
        TextField("Name", text: $name)

        Text("\(region.center.latitude), \(region.center.longitude)")
          .font(.footnote)
          .monospacedDigit()

        Button {

          let station = Station(clCoordinate: region.center, name: name)
          stationsStore.stations.append(station)

          presentationMode.wrappedValue.dismiss()
        } label: {
          Text("Save")
        }
        .buttonStyle(.bordered)
        .padding()
      }
      .padding()

      Spacer()
    }
    .edgesIgnoringSafeArea(.top)
    .onAppear {
      region = MKCoordinateRegion(center: location.coordinate,
                                  latitudinalMeters: 1000,
                                  longitudinalMeters: 1000)
    }
  }
}

struct InputView_Previews: PreviewProvider {
  static var previews: some View {
    InputView(location: CLLocation(latitude: 50, longitude: 6), stationsStore: StationsStore())
  }
}
