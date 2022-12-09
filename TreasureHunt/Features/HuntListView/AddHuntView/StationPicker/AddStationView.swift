//
//  AddStationView.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 07.12.22.
//

import SwiftUI

//MARK: - AddNewStationView
struct AddStationView: View {
  @Environment(\.dismiss) private var dismiss
  @EnvironmentObject private var viewModel: AddHuntViewModel
  @EnvironmentObject private var locationProvider: LocationProvider

  private var stationToEdit: THStation?

  @State private var title: String = ""
  @State private var task: String = ""
  @State private var location: THLocation?

  @State private var locationSelectionSheetIsShown: Bool = false

  private var isValidStation: Bool {
    return !title.trimmingCharacters(in: .whitespaces).isEmpty && !(location == nil)
  }

  init() {}

  init(station: THStation) {
    self.stationToEdit = station
    _title = State(initialValue: station.unwrappedTitle)
    if let task = station.task {
      _task = State(initialValue: task)
    }
    if let location = station.location {
      _location = State(initialValue: location)
    }
  }

  var body: some View {
    NavigationStack {
      ScrollView(.vertical) {
        // Name
        HStack(alignment: .firstTextBaseline) {
          THNumberedCircle(number: 1)

          VStack(alignment: .leading, spacing: Constants.rowSpacing) {
            Text("Name")
              .font(.headline)
            TextField("Name", text: $title)
              .padding()
              .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: Constants.cornerRadius))
          }
        }

        // Task
        HStack(alignment: .firstTextBaseline) {
          THNumberedCircle(number: 2)
          VStack(alignment: .leading, spacing: Constants.rowSpacing) {
            Text("Task")
              .font(.headline)
            TextField("Task", text: $task)
              .lineLimit(1...5)
              .padding()
              .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: Constants.cornerRadius))
          }
        }

        // Location
        HStack(alignment: .firstTextBaseline) {
          THNumberedCircle(number: 3)
          VStack(alignment: .leading, spacing: Constants.rowSpacing) {
            Text("Location")
              .font(.headline)

            selectableLocationView
          }
        }
        .sheet(isPresented: $locationSelectionSheetIsShown) {
          AddHuntView.LocationPicker(location: $location)
        }

        HStack {
          Spacer()

          Button("Save", action: saveButtonPressed)
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(!isValidStation)
        }
        .padding(.top, Constants.rowSpacing)
      }
      .padding(.horizontal)
      .navigationTitle(title.isEmpty ? "New Station" : title)
      .roundedNavigationTitle()
      .toolbar {
        Button(iconName: "xmark.circle.fill", action: dismiss.callAsFunction)
      }
    }
  }

  private func saveButtonPressed() {
    if stationToEdit != nil {
      updateStation()
    } else{
      saveNewStation()
    }
    dismiss()
  }

  private func updateStation() {
    if let stationToEdit {
      stationToEdit.title = title
      stationToEdit.location = location
    }
  }

  private func saveNewStation() {
    let station = THStation(context: PersistenceController.shared.context)
    station.id = .init()
    station.index = Int64(viewModel.stations.count)
    station.title = title
    station.location = location
    viewModel.stations.append(station)
  }

  private var selectableLocationView: some View {
    HStack {
      if let location {
        Text(location.unwrappedTitle)
          .font(.system(.title3, design: .rounded, weight: .semibold))
          .fontWeight(.semibold)

        Spacer()

        VStack(alignment: .trailing) {
          Text(locationProvider.distanceToAsString(location.location))
          Text(L10n.HuntListDetailRowView.distanceFromHere)
            .font(.system(.caption, design: .rounded, weight: .light))
        }
      } else {
        VStack {
          Text("No Location Selected")
            .font(.system(.body, design: .rounded, weight: .semibold))
          Text("Tap to select one.")
            .font(.system(.footnote, design: .rounded, weight: .semibold))
            .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .center)
      }
    }
    .padding(.vertical, 4)
    .padding()
    .background(
      RoundedRectangle(cornerRadius: Constants.cornerRadius)
        .fill(.regularMaterial)
    )
    .contentShape(Rectangle())
    .onTapGesture {
      locationSelectionSheetIsShown = true
    }
  }
  }
