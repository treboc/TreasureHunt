//  Created by Dominik Hauser on 23.09.22.
//  
//

import RealmSwift
import SwiftUI
import MapKit

struct LocationsListView: View {
  @ObservedResults(THLocation.self) private var locations
  @EnvironmentObject private var locationProvider: LocationProvider
  @AppStorage(UserDefaults.TooltipKeys.editLocations) private var editStationTooltipIsShown = true
  @State private var newLocationSheetIsShown: Bool = false
  @State private var locationToEdit: THLocation? = nil
  @State private var locationToDelete: THLocation? = nil

  var body: some View {
    NavigationStack {
      ZStack {
        if locations.isEmpty {
          noLocationsPlaceholder
        } else {
          locationsList
        }
      }
      .safeAreaInset(edge: .bottom) {
        locationUpdateInfoText
      }
      .navigationTitle(L10n.LocationsListView.navTitle)
      .roundedNavigationTitle()
      .sheet(isPresented: $newLocationSheetIsShown) {
        AddLocationView(location: locationProvider.currentLocation)
      }
      .sheet(item: $locationToEdit) { location in
        AddLocationView(location: location)
      }
      .toolbar(content: toolbarContent)
    }
  }
}

struct StationsListView_Previews: PreviewProvider {
  static var previews: some View {
    LocationsListView()
      .environmentObject(LocationProvider())
  }
}

extension LocationsListView {
  // MARK: - ToolbarItems
  @ToolbarContentBuilder
  func toolbarContent() -> some ToolbarContent {
    ToolbarItem(placement: .navigationBarTrailing) {
      if locationProvider.currentLocation == nil {
        ProgressView()
      } else {
        Button(iconName: "plus") {
          newLocationSheetIsShown.toggle()
        }
        .disabled(locationProvider.currentLocation == nil)
      }
    }
  }

  private var noLocationsPlaceholder: some View {
    VStack(spacing: 30) {
      Text(L10n.LocationsListView.listPlaceholderText)
        .multilineTextAlignment(.center)
        .font(.system(.headline, design: .rounded))
      Button(L10n.LocationsListView.listPlaceholderButtonTitle) { newLocationSheetIsShown.toggle() }
        .foregroundColor(Color(uiColor: .systemBackground))
        .buttonStyle(.borderedProminent)
        .controlSize(.regular)
        .disabled(locationProvider.currentLocation == nil)
    }
    .padding(.horizontal, 50)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }

  private var locationsList: some View {
    List(locations) { location in
      LocationsListRowView(location: location)
        .onTapGesture {
          locationToEdit = location
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
          HStack {
            swipeToDelete(location)
            swipeToEdit(location)
          }
        }
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
          swipeToFavorite(location)
        }
        .contextMenu {
          contextMenuContent(location)
        }
    }
    .listStyle(.plain)
    .safeAreaInset(edge: .bottom) {
      if editStationTooltipIsShown {
        editStationTooltipView
      }
    }
    .alert(L10n.Alert.DeleteStation.title, isPresented: .constant(locationToDelete != nil), actions: {
      Button(L10n.BtnTitle.cancel, role: .cancel) {
        locationToDelete = nil
      }
      .tint(Color.accentColor)

      Button(L10n.BtnTitle.iAmSure, role: .destructive) {
        if let locationToDelete {
          withAnimation {
            $locations.remove(locationToDelete)
            self.locationToDelete = nil
          }
        }
      }
    }, message: {
      Text(L10n.Alert.DeleteStation.message)
    })
    .animation(.default, value: locationToDelete)
  }

  private var editStationTooltipView: some View {
    Text(L10n.LocationsListView.editStationTooltip)
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

  private var locationUpdateInfoText: some View {
    VStack {
      Text("Location last updated at:")
      Text(locationProvider.lastLocationUpdate?.formatted(date: .abbreviated, time: .shortened) ?? "")
    }
    .font(.footnote)
    .foregroundColor(.secondary)
    .padding()
    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: Constants.cornerRadius))
    .padding(.bottom)
  }

  @ViewBuilder
  private func contextMenuContent(_ station: THLocation) -> some View {
    Button {
      THLocationService.toggleFavorite(station)
    } label: {
      if station.isFavorite {
        Label("Remove from Favorites", systemImage: "star.fill")
      } else {
        Label("Add to Favorites", systemImage: "star")
      }
    }
    Button {
      locationToEdit = station
    } label: {
      Label("Edit Station", systemImage: "pencil")
    }

    Button(role: .destructive) {
      locationToDelete = station
    } label: {
      Label("Delete", systemImage: "trash")
    }
  }

  private func swipeToDelete(_ station: THLocation) -> some View {
    Button(role: .destructive) {
      locationToDelete = station
    } label: {
      Label(L10n.BtnTitle.delete, systemImage: "trash")
        .labelStyle(.iconOnly)
    }
    .tint(.red)
  }

  private func swipeToEdit(_ station: THLocation) -> some View {
    Button {
      locationToEdit = station
    } label: {
      Label(L10n.BtnTitle.edit, systemImage: "square.and.pencil")
        .labelStyle(.iconOnly)
    }
    .tint(.purple)
  }

  private func swipeToFavorite(_ station: THLocation) -> some View {
    Button {
      withAnimation {
        THLocationService.toggleFavorite(station)
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
    .accessibilityLabel(Text(L10n.LocationsListView.SwipeAction.markFavorite))
  }
}
