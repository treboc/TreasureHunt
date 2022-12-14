//
//  StationsPicker.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 04.10.22.
//

import RealmSwift
import SwiftUI

struct StationsPicker: View {
  @ObservedResults(Station.self) private var stations
  @Binding var chosenStations: [Station]
  @State private var addNewStationViewIsShown: Bool = false

  private var chosenStationsSectionHeader: String {
    return L10n.AddHuntView.chosenStations(chosenStations.count)
  }

  private var availableStations: [Station] {
    let filtered = stations.filter {
      !chosenStations.contains($0)
    }
    return Array(filtered)
  }

  private func add(_ station: Station) {
    if chosenStations.count < 50 {
      chosenStations.append(station)
    }
  }

  private func remove(_ station: Station) {
    if let index = chosenStations.firstIndex(of: station) {
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
      .sheet(isPresented: $addNewStationViewIsShown) { AddStationView() }
      .navigationTitle(L10n.StationsPicker.navTitle)
      .roundedNavigationTitle()
  }
}

struct StationsPicker_Previews: PreviewProvider {
  static var previews: some View {
    StationsPicker(chosenStations: .constant([]))
  }
}

extension StationsPicker {
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
          StationPickerRowView(index: index, station: chosenStations[index], rowType: .chosen)
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
      ForEach(availableStations) { station in
        StationPickerRowView(index: 0, station: station, rowType: .available)
          .onTapGesture {
            add(station)
          }
      }
    }
  }
}

extension StationsPicker {
  private func showAddNewStationView() {
    addNewStationViewIsShown.toggle()
  }

  private func moveStation(from source: IndexSet, to destination: Int) {
    withAnimation {
      chosenStations.move(fromOffsets: source, toOffset: destination)
    }
  }
}
