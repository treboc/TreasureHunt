//  Created by Dominik Hauser on 23.09.22.
//  
//

import SwiftUI

struct StationsListView: View {

  @ObservedObject var stationStore: StationsStore

  var body: some View {
    NavigationView {
      List {
        ForEach(stationStore.stations) { station in
          VStack(alignment: .leading) {
            Text(station.name)

            Text("\(station.coordinate.latitude), \(station.coordinate.longitude)")
              .font(.footnote)
          }
        }
        .onDelete(perform: stationStore.deleteStation)
      }
      .navigationTitle("Stationen")
    }
  }
}

struct StationsListView_Previews: PreviewProvider {
  static var previews: some View {
    StationsListView(stationStore: StationsStore())
  }
}
