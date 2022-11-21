//
//  AddHuntView+StationsPicker.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 19.11.22.
//

import RealmSwift
import SwiftUI

extension AddHuntView {
  struct StationsPicker: View {
    @EnvironmentObject private var viewModel: AddHuntViewModel
    @State private var addNewStationSheetIsShown: Bool = false
    @State private var stationToEdit: THStation?

    var body: some View {
      HStack(alignment: .firstTextBaseline) {
        THNumberedCircle(number: 3)

        VStack {
          VStack(alignment: .leading, spacing: 0) {
            Text("The stations")
              .font(.system(.title3, design: .rounded, weight: .semibold))
            Text("Here you create the stations that must be passed afterwards in the hunt.")
              .font(.system(.footnote, design: .rounded, weight: .regular))
              .foregroundColor(.secondary)
          }
          .frame(maxWidth: .infinity, alignment: .leading)

          List {
            Group {
              ForEach(0..<viewModel.stations.count, id: \.self) { index in
                StationsPickerRowView(station: viewModel.stations[index], index: index)
                  .onTapGesture {
                    stationToEdit = viewModel.stations[index]
                  }
                  .sheet(item: $stationToEdit) { station in
                    AddNewStationView(station: station)
                  }
              }
              .onDelete { indexSet in
                viewModel.stations.remove(atOffsets: indexSet)
              }

              Button {
                addNewStationSheetIsShown = true
              } label: {
                Text(viewModel.stations.isEmpty ? "Create your first station" : "Add another station")
                  .frame(maxWidth: .infinity)
                  .foregroundColor(Color(uiColor: .systemBackground))
              }
              .buttonStyle(.borderedProminent)
              .controlSize(.large)
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
          }
          .listStyle(.plain)
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
      .padding()
      .sheet(isPresented: $addNewStationSheetIsShown) {
        AddNewStationView()
      }
    }

    struct StationsPickerRowView: View {
      let station: THStation
      let index: Int

      @State private var size: CGSize = .zero

      var body: some View {
        HStack {
          Text(station.name)
            .font(.system(.headline, design: .rounded))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 4)
        .padding()
        .background(
          RoundedRectangle(cornerRadius: Constants.cornerRadius)
            .fill(.regularMaterial)
        )
        .overlay {
          THNumberedCircle(number: index + 1)
            .offset(x: -size.width / 2, y: -size.height / 2)
        }
        .readSize { size in
          self.size = size
        }
      }
    }

    //MARK: - AddNewStationView
    struct AddNewStationView: View {
      @Environment(\.dismiss) private var dismiss
      @EnvironmentObject private var viewModel: AddHuntViewModel
      @EnvironmentObject private var locationProvider: LocationProvider
      private var stationToEdit: THStation?

      @State private var name: String = ""
      @State private var task: String = ""
      @State private var location: THLocation?

      @State private var locationSelectionSheetIsShown: Bool = false

      private var isValidStation: Bool {
        return !name.trimmingCharacters(in: .whitespaces).isEmpty && !(location == nil)
      }

      init() {}

      init(station: THStation) {
        self.stationToEdit = station
        _name = State(initialValue: station.name)
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
                TextField("Name", text: $name)
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
              LocationPicker(location: $location)
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
          .navigationTitle(name.isEmpty ? "New Station" : name)
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
        guard var station = viewModel.stations.first(where: { $0._id == stationToEdit?._id }),
              let realm = station.realm?.thaw(),
        let index = viewModel.stations.firstIndex(where: { $0._id == stationToEdit?._id }) else { return }
        if station.isFrozen {
          if let thawedStation = station.thaw() {
            station = thawedStation
          }
        }

        do {
          try realm.write {
            station.name = name
            station.task = task
            viewModel.objectWillChange.send()
            viewModel.stations[index] = station
          }
        } catch {
          print(error)
        }
      }

      private func saveNewStation() {
        guard let location else { return }

        if task.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
          let station = THStation(name: name, task: nil, location: location)
          viewModel.stations.append(station)
        } else {
          task = task.trimmingCharacters(in: .whitespacesAndNewlines)
          let station = THStation(name: name, task: task, location: location)
          viewModel.stations.append(station)
        }
      }

      private var selectableLocationView: some View {
        HStack {
          if let location {
            Text(location.name)
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
  }
}
