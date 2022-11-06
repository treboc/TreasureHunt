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
  @State private var stationToDelete: Station? = nil

  var body: some View {
    NavigationStack {
      ZStack {
        if stations.isEmpty {
          noStationsPlaceholder
        } else {
          stationsList
        }
      }
      .navigationTitle(L10n.StationsListView.navTitle)
      .roundedNavigationTitle()
      .sheet(isPresented: $newStationSheetIsShown, onDismiss: nil) {
        AddStationView(location: locationProvider.currentLocation)
      }
      .sheet(item: $stationToEdit) { station in
        AddStationView(stationToEdit: station)
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
      Text(L10n.StationsListView.listPlaceholderText)
        .multilineTextAlignment(.center)
        .font(.system(.headline, design: .rounded))
      Button(L10n.StationsListView.listPlaceholderButtonTitle) { newStationSheetIsShown.toggle() }
        .foregroundColor(Color(uiColor: .systemBackground))
        .buttonStyle(.borderedProminent)
        .controlSize(.regular)
    }
    .padding(.horizontal, 50)
  }
  private func favoriteSort(_ lhs: Station, _ rhs: Station) -> Bool {
    return lhs.isFavorite
  }

  private var stationsList: some View {
    List {
      ForEach(stations) { station in
        StationsListRowView(station: station)
          .onTapGesture {
            stationToEdit = station
          }
          .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            HStack {
              swipeToDelete(station)
              swipeToEdit(station)
            }
          }
          .swipeActions(edge: .leading, allowsFullSwipe: true) {
            swipeToFavorite(station)
          }
          .contextMenu {
            contextMenuContent(station)
          }
      }
    }
    .listStyle(.plain)
    .safeAreaInset(edge: .bottom) {
      if editStationTooltipIsShown {
        editStationTooltipView
      }
    }
    .alert(L10n.Alert.DeleteStation.title, isPresented: .constant(stationToDelete != nil), actions: {
      Button(L10n.BtnTitle.cancel, role: .cancel) {
        stationToDelete = nil
      }
      .tint(Color.accentColor)

      Button(L10n.BtnTitle.iAmSure, role: .destructive) {
        if let stationToDelete {
          withAnimation {
            $stations.remove(stationToDelete)
            self.stationToDelete = nil
          }
        }
      }
    }, message: {
      Text(L10n.Alert.DeleteStation.message)
    })
    .animation(.default, value: stationToDelete)
  }

  private var editStationTooltipView: some View {
    Text(L10n.StationsListView.editStationTooltip)
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

  @ViewBuilder
  private func contextMenuContent(_ station: Station) -> some View {
    Button {
      StationModelService.toggleFavorite(station)
    } label: {
      if station.isFavorite {
        Label("Remove from Favorites", systemImage: "star.fill")
      } else {
        Label("Add to Favorites", systemImage: "star")
      }
    }
    Button {
      stationToEdit = station
    } label: {
      Label("Edit Station", systemImage: "pencil")
    }

    Button(role: .destructive) {
      stationToDelete = station
    } label: {
      Label("Delete", systemImage: "trash")
    }
  }

  private func swipeToDelete(_ station: Station) -> some View {
    Button(role: .destructive) {
      stationToDelete = station
    } label: {
      Label(L10n.BtnTitle.delete, systemImage: "trash")
        .labelStyle(.iconOnly)
    }
    .tint(.red)
  }

  private func swipeToEdit(_ station: Station) -> some View {
    Button {
      stationToEdit = station
    } label: {
      Label(L10n.BtnTitle.edit, systemImage: "square.and.pencil")
        .labelStyle(.iconOnly)
    }
    .tint(.purple)
  }

  private func swipeToFavorite(_ station: Station) -> some View {
    Button {
      withAnimation {
        StationModelService.toggleFavorite(station)
      }
    } label: {
      if station.isFavorite {
        Label("Unmark as Favorite", systemImage: "star.slash.fill")
          .labelStyle(.iconOnly)
      } else {
        Label("Mark as Favorite", systemImage: "star")
          .labelStyle(.iconOnly)
      }
    }
    .tint(.yellow)
    .accessibilityLabel(Text(L10n.StationsListView.SwipeAction.markFavorite))
  }
}
