//  Created by Dominik Hauser on 21.09.22.
//  
//

import SwiftUI
import MapKit

struct InputView: View {

  @State var name: String = ""
  let location: CLLocation
  @State var region: MKCoordinateRegion = .init(center: CLLocationCoordinate2D(latitude: 50, longitude: 6), latitudinalMeters: 200, longitudinalMeters: 200)

  init(location: CLLocation) {
    self.location = location

    region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
  }

  var body: some View {
    VStack {
      Map(coordinateRegion: $region)
        .frame(height: 300)

      VStack {
        TextField("Name", text: $name)
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
  }
}
