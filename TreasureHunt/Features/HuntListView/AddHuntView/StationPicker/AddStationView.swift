//
//  AddStationView.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 07.12.22.
//

import CoreData
import SwiftUI


//MARK: - AddNewStationView
struct AddStationView: View {
  @Environment(\.dismiss) private var dismiss
  @EnvironmentObject private var viewModel: AddHuntViewModel
  @EnvironmentObject private var locationProvider: LocationProvider

  @ObservedObject private var station: THStation

  @State private var locationSelectionSheetIsShown: Bool = false

  private var isValidStation: Bool {
    return !station.unwrappedTitle.trimmingCharacters(in: .whitespaces).isEmpty && !(station.location == nil)
  }

  init(station: THStation? = nil) {
    self.station = THStationModelService.createStationToEdit(of: station)
  }

  var body: some View {
    NavigationStack {
      ScrollView(.vertical) {
        VStack {
          // Name
          HStack(alignment: .firstTextBaseline) {
            THNumberedCircle(number: 1)

            VStack(alignment: .leading, spacing: Constants.rowSpacing) {
              Text(L10n.AddStationView.title)
                .font(.headline)
              TextField(L10n.AddStationView.title, text: $station.unwrappedTitle)
                .padding()
                .roundedBackground()
            }
          }

          // Task
          HStack(alignment: .firstTextBaseline) {
            THNumberedCircle(number: 2)
            VStack(alignment: .leading, spacing: Constants.rowSpacing) {
              Text(L10n.AddStationView.task)
                .font(.headline)
              TextField(L10n.AddStationView.task, text: $station.unwrappedTask)
                .lineLimit(1...5)
                .padding()
                .roundedBackground()
            }
          }

          // Location
          HStack(alignment: .firstTextBaseline) {
            THNumberedCircle(number: 3)
            VStack(alignment: .leading, spacing: Constants.rowSpacing) {
              Text(L10n.AddStationView.location)
                .font(.headline)

              selectableLocationView
            }
          }
          .sheet(isPresented: $locationSelectionSheetIsShown) {
            AddHuntView.LocationPicker(location: $station.location)
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
      }
      .navigationTitle(
        station.unwrappedTitle.isEmpty
        ? L10n.AddStationView.navTitle
        : station.unwrappedTitle
      )
      .roundedNavigationTitle()
      .toolbar {
        Button(iconName: "xmark.circle.fill", action: dismiss.callAsFunction)
      }
    }
  }

  private func saveButtonPressed() {
    viewModel.saveStation(station)
    dismiss()
  }


  private var selectableLocationView: some View {
    HStack {
      if let location = station.location {
        Text(location.unwrappedTitle)
          .font(.system(.title3, design: .rounded, weight: .semibold))
          .fontWeight(.semibold)

        Spacer()

        VStack(alignment: .trailing) {
          Text(locationProvider.distanceTo(location.location))
          Text(L10n.HuntListDetailRowView.distance)
            .font(.system(.caption, design: .rounded, weight: .light))
        }
      } else {
        VStack {
          Text(L10n.AddHuntView.OutroPage.SelectableLocationView.noLocationSelected)
            .font(.system(.body, design: .rounded, weight: .semibold))
          Text(L10n.AddHuntView.OutroPage.SelectableLocationView.noLocationSelected)
            .font(.system(.footnote, design: .rounded, weight: .semibold))
            .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .center)
      }
    }
    .padding(.vertical, 4)
    .padding()
    .roundedBackground()
    .contentShape(Rectangle())
    .onTapGesture {
      locationSelectionSheetIsShown = true
    }
  }
}
