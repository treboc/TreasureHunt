//
//  AddHuntView+StationsPicker.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 19.11.22.
//

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
                    AddStationView(station: station)
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
        AddStationView()
      }
    }

    struct StationsPickerRowView: View {
      let station: THStation
      let index: Int

      @State private var size: CGSize = .zero

      var body: some View {
        HStack {
          Text(station.unwrappedTitle)
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
  }
}
