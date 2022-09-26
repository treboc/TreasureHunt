//  Created by Dominik Hauser on 23.09.22.
//  
//

import SwiftUI
import MapKit

final class StationsListViewModel: ObservableObject {
  @Published var chosenStations: [Station] = []

  func toggleStationChosenState(_ station: Station) {
    withAnimation {
      if let index = chosenStations.firstIndex(of: station) {
        chosenStations.remove(at: index)
      } else {
        chosenStations.append(station)
      }
    }
  }

  func positionOf(_ station: Station) -> Int? {
    if let index = chosenStations.firstIndex(of: station) {
      return index + 1
    } else {
      return nil
    }
  }
}

struct StationsListView: View {
  @StateObject private var viewModel = StationsListViewModel()
  @EnvironmentObject private var locationProvider: LocationProvider
  @EnvironmentObject private var stationStore: StationsStore
  @State private var newStationSheetIsShown: Bool = false

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
      .toolbar(content: toolbarContent)
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

extension StationsListView {
  @ViewBuilder
  private var startHuntButton: some View {
    if !viewModel.chosenStations.isEmpty {
      NavigationLink("Suche starten!") {
        HuntView()
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
