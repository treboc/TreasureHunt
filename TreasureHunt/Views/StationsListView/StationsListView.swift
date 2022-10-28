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
  @State private var stationDeletionAlertIsShown: Bool = false
  @State private var stationToDelete: Station? = nil

  var body: some View {
    NavigationView {
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
        AddStationView(location: locationProvider.locationManager.location)
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
      ForEach(stations.sorted(by: favoriteSort), id: \._id) { station in
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
      }
    }
    .safeAreaInset(edge: .bottom) {
      if editStationTooltipIsShown {
        editStationTooltipView
      }
    }
    .alert(L10n.Alert.DeleteStation.title, isPresented: $stationDeletionAlertIsShown, actions: {
      Button(L10n.BtnTitle.cancel, role: .cancel) {}
        .tint(Color.accentColor)
      Button(L10n.BtnTitle.iAmSure, role: .destructive) {
        if let stationToDelete {
          withAnimation {
            $stations.remove(stationToDelete)
          }
        }
      }
    }, message: {
      Text(L10n.Alert.DeleteStation.message)
    })
    .animation(.default, value: stationDeletionAlertIsShown)
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

  private func swipeToDelete(_ station: Station) -> some View {
    Button {
      stationToDelete = station
      stationDeletionAlertIsShown = true
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
    .tint(.orange)
  }

  private func swipeToFavorite(_ station: Station) -> some View {
    Button {
      withAnimation {
        StationModelService.toggleFavorite(station)
      }
    } label: {
      Image(systemName: "star.fill")
    }
    .tint(.yellow)
    .accessibilityLabel(Text(L10n.StationsListView.SwipeAction.markFavorite))
  }
}
