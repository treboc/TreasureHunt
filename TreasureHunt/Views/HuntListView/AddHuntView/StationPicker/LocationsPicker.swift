//
//  LocationsPicker.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 04.10.22.
//

import RealmSwift
import SwiftUI

struct LocationsPicker: View {
  @ObservedResults(THLocation.self) private var locations
  @EnvironmentObject var locationProvider: LocationProvider
  @Binding var chosenStations: [THLocation]
  @State private var addNewLocationViewIsShown: Bool = false

  private var chosenStationsSectionHeader: String {
    return L10n.AddHuntView.chosenStations(chosenStations.count)
  }

  private var availableStations: [THLocation] {
    let filtered = locations.filter {
      !chosenStations.contains($0)
    }
    return Array(filtered)
  }

  private func add(_ location: THLocation) {
    if chosenStations.count < 50 {
      chosenStations.append(location)
    }
  }

  private func remove(_ location: THLocation) {
    if let index = chosenStations.firstIndex(of: location) {
      chosenStations.remove(at: index)
    }
  }

  var body: some View {
      Form {
        createStationButton
        chosenStationsSection
        if !availableStations.isEmpty {
          availableStationsSection
        }
      }
      .sheet(isPresented: $addNewLocationViewIsShown) {
        AddLocationView(location: locationProvider.currentLocation)
      }
      .navigationTitle(L10n.StationsPicker.navTitle)
      .roundedNavigationTitle()
  }
}

struct StationsPicker_Previews: PreviewProvider {
  static var previews: some View {
    LocationsPicker(chosenStations: .constant([]))
  }
}

extension LocationsPicker {
  private var createStationButton: some View {
    Button(action: showAddNewStationView) {
      HStack {
        Text(L10n.StationsPicker.addStationButtonTitle)
        Spacer()
        Image(systemName: "plus")
      }
      .foregroundColor(.accentColor)
    }
  }

  @ViewBuilder
  private var chosenStationsSection: some View {
    Section(chosenStationsSectionHeader) {
      if !chosenStations.isEmpty {
        ForEach(0..<chosenStations.count, id: \.self) { index in
          StationPickerRowView(index: index, location: locations[index], rowType: .chosen)
            .onTapGesture {
              remove(chosenStations[index])
            }
        }
        .onMove(perform: moveStation)
      } else {
        Text(L10n.StationsPicker.noChosenStations)
          .italic()
          .foregroundColor(.secondary)
      }
    }
  }

  private var availableStationsSection: some View {
    Section(L10n.StationsPicker.availableStations) {
      ForEach(availableStations) { location in
        StationPickerRowView(index: 0, location: location, rowType: .available)
          .onTapGesture {
            add(location)
          }
      }
    }
  }
}

extension LocationsPicker {
  private func showAddNewStationView() {
    addNewLocationViewIsShown.toggle()
  }

  private func moveStation(from source: IndexSet, to destination: Int) {
    withAnimation {
      chosenStations.move(fromOffsets: source, toOffset: destination)
    }
  }
}
