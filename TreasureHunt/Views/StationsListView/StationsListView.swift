//  Created by Dominik Hauser on 23.09.22.
//  
//

import RealmSwift
import SwiftUI
import MapKit

struct StationsListView: View {
  @ObservedResults(Station.self) private var stations
  @EnvironmentObject private var locationProvider: LocationProvider
  @AppStorage(UserDefaultsKeys.Tooltips.editStations) private var editStationTooltipIsShown = true
  @State private var newStationSheetIsShown: Bool = false
  @State private var stationToEdit: Station? = nil

  var body: some View {
    NavigationView {
      ZStack {
        if stations.isEmpty {
          noStationsPlaceholder
        } else {
          stationsList
        }
      }
      .navigationTitle("Stationen")
      .roundedNavigationTitle()
      .sheet(isPresented: $newStationSheetIsShown, onDismiss: nil) {
        AddNewStationView(location: locationProvider.locationManager.location)
      }
      .sheet(item: $stationToEdit) { station in
        AddNewStationView(stationToEdit: station)
      }
      .toolbar(content: toolbarContent)
    }
  }
}

struct StationsListView_Previews: PreviewProvider {
  static var previews: some View {
    StationsListView()
      .environmentObject(LocationProvider())
  }
}

extension StationsListView {
  // MARK: - ToolbarItems
  @ToolbarContentBuilder
  func toolbarContent() -> some ToolbarContent {
    ToolbarItem(placement: .navigationBarTrailing) {
      Button(iconName: "plus") {
        newStationSheetIsShown.toggle()
      }
    }
  }

  private var noStationsPlaceholder: some View {
    VStack(spacing: 30) {
      Text("Du hast noch keine Stationen erstellt, aber fang' doch gleich damit an, in dem du hier, oder oben rechts auf das \"+\" tippst.")
        .multilineTextAlignment(.center)
        .font(.system(.headline, design: .rounded))
      Button("Erstelle eine Station") { newStationSheetIsShown.toggle() }
        .foregroundColor(Color(uiColor: .systemBackground))
        .buttonStyle(.borderedProminent)
        .controlSize(.regular)
    }
    .padding(.horizontal, 50)
  }

  private var stationsList: some View {
    List {
      ForEach(stations, id: \._id) { station in
        StationsListRowView(station: station)
          .onTapGesture {
            stationToEdit = station
          }
          .swipeActions(edge: .trailing, allowsFullSwipe: true, content: {
            HStack {
              swipeToDelete(station)
              swipeToEdit(station)
            }
          })
      }
    }
    .safeAreaInset(edge: .bottom) {
      if editStationTooltipIsShown {
        Text("Tipp: Tippe eine Station in der Liste an, um sie zu bearbeiten.")
          .foregroundColor(.secondary)
          .font(.footnote)
          .italic()
          .padding()
          .background(
            RoundedRectangle(cornerRadius: 16)
              .fill(.ultraThinMaterial)
              .shadow(radius: 8)
              .overlay(alignment: .topTrailing) {
                Image(systemName: "x.circle.fill")
                  .font(.title2)
                  .foregroundColor(.gray)
                  .offset(x: 10, y: -10)
                  .onTapGesture {
                    editStationTooltipIsShown = false
                  }
              }
          )
          .padding()
      }
    }
  }

  private func swipeToDelete(_ station: Station) -> some View {
    Button {
      $stations.remove(station)
    } label: {
      Label("Löschen", systemImage: "trash")
    }
    .tint(.red)
  }

  private func swipeToEdit(_ station: Station) -> some View {
    Button {
      stationToEdit = station
    } label: {
      Label("Edit", systemImage: "square.and.pencil")
    }
    .tint(.orange)
  }
}
