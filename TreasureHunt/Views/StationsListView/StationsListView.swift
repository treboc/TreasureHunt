//  Created by Dominik Hauser on 23.09.22.
//  
//

import SwiftUI
import MapKit

struct StationsListView: View {
  @EnvironmentObject private var locationProvider: LocationProvider
  @EnvironmentObject private var stationStore: StationsStore
  @State private var newStationSheetIsShown: Bool = false

  var body: some View {
    NavigationView {
      List {
        ForEach(0..<stationStore.stations.count, id: \.self) { index in
          StationsListRowView(id: index + 1, station: stationStore.stations[index])
        }
        .onDelete(perform: stationStore.deleteStation)
        .onMove(perform: move)
      }
      .listStyle(.plain)
      .navigationTitle("Stationen")
      .sheet(isPresented: $newStationSheetIsShown, onDismiss: nil, content: AddNewStationView.init)
      .toolbar(content: toolbarContent)
    }
    .onAppear(perform: locationProvider.stop)
    .onDisappear(perform: locationProvider.start)
  }

  func move(from source: IndexSet, to destination: Int) {
    stationStore.stations.move(fromOffsets: source, toOffset: destination)
  }
}

struct StationsListView_Previews: PreviewProvider {
  static var previews: some View {
    StationsListView()
      .environmentObject(StationsStore())
      .environmentObject(LocationProvider())
  }
}

extension StationsListView {
  // MARK: - ToolbarItems
  @ToolbarContentBuilder
  func toolbarContent() -> some ToolbarContent {
    ToolbarItem(placement: .navigationBarTrailing) {
      Button {
        newStationSheetIsShown = true
      } label: {
        Image(systemName: "plus")
      }
    }

    ToolbarItem(placement: .navigationBarLeading) {
      EditButton()
    }
  }
}
