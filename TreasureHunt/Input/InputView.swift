//  Created by Dominik Hauser on 21.09.22.
//  
//

import SwiftUI
import MapKit

struct InputView: View {
  @EnvironmentObject private var stationsStore: StationsStore
  @Environment(\.dismiss) private var dismiss
  @State var name: String = ""
  @State var region: MKCoordinateRegion

  init(location: CLLocation) {
    let region = MKCoordinateRegion(center: location.coordinate,
                                latitudinalMeters: 1000,
                                longitudinalMeters: 1000)
    _region = State(initialValue: region)
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
          dismiss()
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
  }
}

struct InputView_Previews: PreviewProvider {
  static var previews: some View {
    InputView(location: CLLocation(latitude: 50, longitude: 6))
      .environmentObject(StationsStore())
  }
}

extension InputView {
  private func saveButtonTapped() {
    let location = region.center
    stationsStore.newStation(with: name, and: location)
  }
}
