//  Created by Dominik Hauser on 23.09.22.
//  
//

import SwiftUI
import MapKit

struct StationsListView: View {
  @Environment(\.editMode) private var editMode
  @EnvironmentObject private var stationStore: StationsStore
  @StateObject private var viewModel = StationsListViewModel()

  var body: some View {
    NavigationView {
      List {
        ForEach(stationStore.allStations) { station in
          StationsListRowView(position: viewModel.positionOf(station), station: station)
            .onTapGesture {
              viewModel.toggleStationChosenState(station)
            }
        }
        .onDelete(perform: stationStore.deleteStation)
        .onMove(perform: stationStore.moveStation)
      }
      .overlay(alignment: .bottom) {
        startHuntButton
      }
      .listStyle(.plain)
      .navigationTitle("Stationen")
      .sheet(isPresented: $newStationSheetIsShown, onDismiss: nil, content: AddNewStationView.init)
      .fullScreenCover(isPresented: $viewModel.huntIsStarted) {
        HuntView(stations: viewModel.chosenStations)
      }
      .toolbar(content: toolbarContent)
    }
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
  @ViewBuilder
  private var startHuntButton: some View {
    if !viewModel.chosenStations.isEmpty {
      Button("Suche starten!") {
        viewModel.huntIsStarted = true
      }
      .buttonStyle(.borderedProminent)
      .controlSize(.large)
      .padding(.bottom, 30)
      .transition(.opacity.combined(with: .move(edge: .bottom)))
    }
  }

  // MARK: - ToolbarItems
  @ToolbarContentBuilder
  func toolbarContent() -> some ToolbarContent {
    ToolbarItem(placement: .navigationBarTrailing) {
      Button(iconName: "plus") {
        newStationSheetIsShown = true
      }
    }

    ToolbarItem(placement: .navigationBarLeading) {
      EditButton()
    }
  }
}
