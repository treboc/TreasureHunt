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
      ZStack {
        if stationStore.allStations.isEmpty {
          noStationsPlaceholder
        } else {
          stationsList
        }
      }
      .navigationTitle("Stationen")
      .roundedNavigationTitle()
      .sheet(isPresented: $viewModel.newStationSheetIsShown, onDismiss: nil, content: AddNewStationView.init)
      .fullScreenCover(isPresented: $viewModel.huntIsStarted, onDismiss: viewModel.resetState) {
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
      Button(iconName: "plus", action: viewModel.showNewStationSheet)
    }

    ToolbarItem(placement: .navigationBarLeading) {
      if stationStore.allStations.isEmpty == false {
        EditButton()
      }
    }
  }

  private var noStationsPlaceholder: some View {
    VStack(spacing: 30) {
      Text("Du hast noch keine Stationen erstellt, aber fang' doch gleich damit an, in dem du hier, oder oben rechts auf das \"+\" tippst.")
        .multilineTextAlignment(.center)
        .font(.system(.headline, design: .rounded))
      Button("Erstelle eine Station", action: viewModel.showNewStationSheet)
        .foregroundColor(Color(uiColor: .systemBackground))
        .buttonStyle(.borderedProminent)
        .controlSize(.regular)
    }
    .padding(.horizontal, 50)
  }

  private var stationsList: some View {
    List {
      ForEach(stationStore.allStations) { station in
        StationsListRowView(position: viewModel.positionOf(station), station: station)
          .onTapGesture {
            if editMode?.wrappedValue.isEditing == false {
              viewModel.toggleStationChosenState(station)
            }
          }
      }
      .onDelete(perform: stationStore.deleteStation)
      .onMove(perform: stationStore.moveStation)
    }
    .overlay(alignment: .bottom) {
      startHuntButton
    }
    .listStyle(.plain)
  }

}
