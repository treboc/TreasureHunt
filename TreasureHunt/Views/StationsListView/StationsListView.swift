//  Created by Dominik Hauser on 23.09.22.
//  
//

import SwiftUI
import MapKit

struct StationsListView: View {
  @EnvironmentObject private var locationProvider: LocationProvider
  @EnvironmentObject private var stationStore: StationsStore

  var body: some View {
    NavigationView {
      List {
        ForEach(0..<stationStore.stations.count, id: \.self) { index in
          StationsListRowView(id: index + 1, station: stationStore.stations[index])
        }
        .onDelete(perform: stationStore.deleteStation)
      }
      .navigationTitle("Stationen")
    }
    .onAppear(perform: locationProvider.stop)
    .onDisappear(perform: locationProvider.start)
  }
}

struct StationsListView_Previews: PreviewProvider {
  static var previews: some View {
    StationsListView()
      .environmentObject(StationsStore())
      .environmentObject(LocationProvider())
  }
}


