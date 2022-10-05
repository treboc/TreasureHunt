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
  @EnvironmentObject private var huntsStore: HuntsStore

  @State private var name: String = ""
  @State private var chosenStations: [Station] = []
  @State private var region: MKCoordinateRegion
  @State private var mapIsShown: Bool = true
  @Namespace private var namespace

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
                StationPickerRowView(index: index, station: chosenStations[index])
              }
              .onMove(perform: moveStation)
              .onDelete(perform: deleteStation)
            }
          }
        }
      }
      .toolbar(content: toolbarContent)
      .navigationTitle(name.isEmpty ? "Neue Jagd" : name)
      .roundedNavigationTitle()
    }
  }

  init() {
    let locationProvider = LocationProvider()
    locationProvider.locationManager.requestLocation()
    let region = MKCoordinateRegion(center: locationProvider.locationManager.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
    _region = State(initialValue: region)
  }
}

struct AddHuntView_Previews: PreviewProvider {
  static var previews: some View {
    AddHuntView()
  }
}

extension AddHuntView {
  func saveButtonTapped(onCompletion: @escaping (() -> Void)) {
    let hunt = Hunt(name: name, stations: chosenStations)
    huntsStore.persist(hunt) {
      onCompletion()
    }
  }

  func moveStation(fromOffsets: IndexSet, toOffset: Int) {
    chosenStations.move(fromOffsets: fromOffsets, toOffset: toOffset)
  }

  func deleteStation(at indexSet: IndexSet) {
    chosenStations.remove(atOffsets: indexSet)
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
        Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: chosenStations, annotationContent: { station in
          MapAnnotation(coordinate: station.location.coordinate) {
            let index = chosenStations.firstIndex(of: station) ?? 0
            AddHuntStationAnnotationView(position: index + 1)
          }
        })
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
        .matchedGeometryEffect(id: "header", in: namespace)
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
      .matchedGeometryEffect(id: "header", in: namespace)
    }
  }
}
