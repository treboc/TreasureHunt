//  Created by Dominik Hauser on 23.09.22.
//  
//

import SwiftUI

struct StationsListView: View {

  var stationStore: StationsStore

  var body: some View {
    VStack {
      Text("Stationen")
        .font(.headline)
        .padding()
      List {
        ForEach(stationStore.stations) { station in
          VStack(alignment: .leading) {
            Text(station.name)

            Text("\(station.coordinate.latitude), \(station.coordinate.longitude)")
              .font(.footnote)
          }
        }
        .onDelete { indexSet in
          if let index = indexSet.first {
            stationStore.stations.remove(at: index)
          }
        }
      }
    }
  }
}

struct StationsListView_Previews: PreviewProvider {
  static var previews: some View {
    StationsListView(stationStore: StationsStore())
  }
}
