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
            Text(L10n.AddHuntView.StationsPicker.title)
              .font(.system(.title3, design: .rounded, weight: .semibold))
            Text(L10n.AddHuntView.StationsPicker.description)
              .font(.system(.footnote, design: .rounded, weight: .regular))
              .foregroundColor(.secondary)
          }
          .frame(maxWidth: .infinity, alignment: .leading)

          List {
            Group {
              ForEach(0..<viewModel.stations.count, id: \.self) { index in
                let station = viewModel.stations[index]
                StationsPickerRowView(station: station, index: index)
                  .onTapGesture {
                    stationToEdit = station
                  }
              }
              .onDelete { indexSet in
                viewModel.stations.remove(atOffsets: indexSet)
              }

              Button {
                addNewStationSheetIsShown = true
              } label: {
                Text(L10n.AddHuntView.StationsPicker.addStation)
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
      .sheet(item: $stationToEdit) { station in
        AddStationView(station: station)
      }
    }

    struct StationsPickerRowView: View {
      @ObservedObject var station: THStation
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
          ZStack(alignment: .topLeading) {
            THNumberedCircle(number: index + 1)

            if station.location == nil {
              HStack(spacing: 2) {
                Image(systemName: "exclamationmark.circle.fill")
                  .font(.title3)
                  .foregroundColor(.red)

                Text("No Location")
                  .font(.footnote)
                  .foregroundColor(.secondary)
              }
              .offset(x: 15)
            }
          }
          .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
          .offset(x: -10, y: -10)
        }
        .readSize { size in
          self.size = size
        }
      }
    }
  }
}
