//  Created by Dominik Hauser on 23.09.22.
//  
//

import SwiftUI
import MapKit

struct StationsListView: View {
  @StateObject private var stationsStore = StationsStore()
  @StateObject private var viewModel = StationsListViewModel()

  var body: some View {
    NavigationView {
      ZStack {
        if stationsStore.allStations.isEmpty {
          noStationsPlaceholder
        } else {
          stationsList
        }
      }
      .navigationTitle("Stationen")
      .roundedNavigationTitle()
      .sheet(isPresented: $viewModel.newStationSheetIsShown, onDismiss: nil) {
        AddNewStationView()
      }
      .sheet(item: $viewModel.stationToEdit) { station in
        AddNewStationView(stationToEdit: station)
      }
      .toolbar(content: toolbarContent)
    }
    .environmentObject(stationsStore)
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
      Button(iconName: "plus", action: viewModel.showNewStationSheet)
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
      ForEach(stationsStore.allStations) { station in
        StationsListRowView(station: station)
          .swipeActions(edge: .trailing, allowsFullSwipe: true, content: {
            HStack {
              swipeToDelete(station)
              swipeToEdit(station)
            }
          })
      }
    }
  }

  private func swipeToDelete(_ station: Station) -> some View {
    Button {
      stationsStore.delete(station)
    } label: {
      Label("Löschen", systemImage: "trash")
    }
    .tint(.red)
  }

  private func swipeToEdit(_ station: Station) -> some View {
    Button {
      viewModel.stationToEdit = station
    } label: {
      Label("Edit", systemImage: "square.and.pencil")
    }
    .tint(.orange)
  }
}
