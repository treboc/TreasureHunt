//
//  AddHuntView.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 03.10.22.
//

import SwiftUI
import MapKit
import RealmSwift

struct AddHuntView: View {
  @EnvironmentObject private var locationProvider: LocationProvider
  @Environment(\.dismiss) private var dismiss

  private var huntToEdit: Hunt?

  @State private var name: String = ""
  @State private var chosenStations: [Station] = []
  @State private var region: MKCoordinateRegion = .init()
  @State private var mapIsShown: Bool = false

  private var saveButtonIsDisabled: Bool {
    return name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || chosenStations.isEmpty
  }

  init(huntToEdit: Hunt? = nil) {
    if let huntToEdit {
      self.huntToEdit = huntToEdit
      _name = State(initialValue: huntToEdit.name)
      let stations: [Station] = Array(huntToEdit.stations)
      _chosenStations = State(initialValue: stations)
    }
  }

  var body: some View {
    NavigationView {
      Form {
        Section(L10n.AddHuntView.name) {
          TextField(L10n.AddHuntView.namePlaceholder, text: $name)
        }

        Section {
          NavigationLink(L10n.AddHuntView.editStations) {
            StationsPicker(chosenStations: $chosenStations)
          }
        }

        stationOverview

        Section(L10n.AddHuntView.chosenStations(chosenStations.count)) {
          if chosenStations.isEmpty {
            Text(L10n.AddHuntView.noChosenStations)
              .italic()
              .foregroundColor(.secondary)
          } else {
            List {
              ForEach(0..<chosenStations.count, id: \.self) { index in
                StationPickerRowView(index: index, station: chosenStations[index], rowType: .chosen)
              }
            }
          }
        }
      }
      .toolbar(content: toolbarContent)
      .navigationTitle(name.isEmpty ? L10n.AddHuntView.navTitle : name)
      .roundedNavigationTitle()
      .task {
        centerLocation()
      }
    }
  }
}

struct AddHuntView_Previews: PreviewProvider {
  static var previews: some View {
    AddHuntView()
  }
}

extension AddHuntView {
  func saveButtonTapped(onCompletion: @escaping (() -> Void)) {
    if let huntToEdit {
      try? HuntModelService.update(huntToEdit, with: name, and: chosenStations)
    } else {
      let hunt = Hunt(name: name)
      HuntModelService.add(hunt, with: chosenStations)
    }
    dismiss()
  }

  private func centerLocation() {
    let center = locationProvider.locationManager.location?.coordinate ?? .init()
    region = MKCoordinateRegion(center: center, latitudinalMeters: 150, longitudinalMeters: 150)
  }
}

extension AddHuntView {
  // MARK: - Views
  @ToolbarContentBuilder
  func toolbarContent() -> some ToolbarContent {
    ToolbarItem(placement: .navigationBarLeading) {
      Button(L10n.BtnTitle.cancel, action: dismiss.callAsFunction)
    }

    ToolbarItem(placement: .navigationBarTrailing) {
      Button(L10n.BtnTitle.save) {
        saveButtonTapped(onCompletion: dismiss.callAsFunction)
      }
      .disabled(saveButtonIsDisabled)
    }
  }

  @ViewBuilder
  private var stationOverview: some View {
    if mapIsShown {
      Section {
        ZStack(alignment: .topTrailing) {
          Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: chosenStations, annotationContent: { station in
            MapAnnotation(coordinate: station.coordinate) {
              let index = chosenStations.firstIndex(of: station) ?? 0
              AddHuntStationAnnotationView(position: index + 1)
            }
          })
          .overlay(alignment: .topTrailing) { centerMapButton }
        }
        .frame(height: 300)
      } header: {
        HStack {
          Text(L10n.AddHuntView.overview)
          Spacer()
          Image(systemName: "chevron.down")
            .rotationEffect(Angle(degrees: mapIsShown ? 0 : -90))
        }
        .padding()
        .contentShape(Rectangle())
        .onTapGesture {
          withAnimation {
            mapIsShown.toggle()
          }
        }
      }
      .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
    } else {
      HStack {
        Text(L10n.AddHuntView.stationsOverview)
        Spacer()
        Image(systemName: "chevron.down")
          .rotationEffect(Angle(degrees: mapIsShown ? 0 : -90))
      }
      .contentShape(Rectangle())
      .onTapGesture {
        withAnimation {
          mapIsShown.toggle()
        }
      }
    }
  }

  private var centerMapButton: some View {
    Button(action: centerLocation) {
      ZStack {
        Circle()
          .fill(.background)
        Image(systemName: "mappin.and.ellipse")
          .foregroundColor(.primary)
      }
      .frame(width: 32, height: 32)
    }
    .padding()
    .contentShape(Circle())
  }
}
