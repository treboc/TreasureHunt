//
//  AddHuntView.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 03.10.22.
//

import SwiftUI
import MapKit

struct AddHuntView: View {
  @Environment(\.dismiss) private var dismiss
  @EnvironmentObject private var locationProvider: LocationProvider

  @State private var name: String = ""
  @State private var chosenStations: [Station] = []
  @State private var region: MKCoordinateRegion = .init()
  @State private var mapIsShown: Bool = true

  private var saveButtonIsDisabled: Bool {
    return name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || chosenStations.isEmpty
  }

  var body: some View {
    NavigationView {
      Form {
        Section("Name der Jagd") {
          TextField("Kindergeburtstag 🎁", text: $name)
        }

        Section {
          NavigationLink("Station hinzufügen") {
            StationsPicker(chosenStations: $chosenStations)
          }
        }

        stationOverview

        Section("Gewählte Stationen (\(chosenStations.count) / 50)") {
          if chosenStations.isEmpty {
            Text("Noch keine Station gewählt.")
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
      .navigationTitle(name.isEmpty ? "Neue Jagd" : name)
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
    let hunt = Hunt(name: name)
    HuntModelService.add(hunt, with: chosenStations)
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
      Button("Abbrechen", action: dismiss.callAsFunction)
    }

    ToolbarItem(placement: .navigationBarTrailing) {
      Button("Speichern") {
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
          Text("Übersicht")
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
        Text("Übersicht")
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
