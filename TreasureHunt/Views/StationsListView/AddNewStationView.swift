//  Created by Dominik Hauser on 21.09.22.
//  
//

import SwiftUI
import MapKit

struct AddNewStationView: View {
  enum Field: Hashable {
    case name, question
  }

  @EnvironmentObject private var stationsStore: StationsStore
  @EnvironmentObject private var locationProvider: LocationProvider

  @Environment(\.dismiss) private var dismiss

  @State private var region: MKCoordinateRegion = .init()
  @State private var name: String = ""
  @State private var question: String = ""
  @State private var triggerDistance: Double = 50
  @FocusState private var focusedField: Field?

  private var saveButtonIsDisabled: Bool {
    return name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
  }

  private var mapSpanInMeters: CLLocationDistance {
    return triggerDistance * 10
  }

  var body: some View {
    NavigationView {
      Form {
        Section {
//          MapView(region: $region, radius: $triggerDistance)
          Map(coordinateRegion: $region)
            .overlay(
              Image(systemName: "plus")
                .allowsHitTesting(false)
            )
            .overlay(
              Circle()
                .strokeBorder(Color.red, lineWidth: 1)
                .background(Circle().foregroundColor(Color.black.opacity(0.1)))
                .frame(width: 60, height: 60)
            )
            .overlay(alignment: .bottom, content: locationCoordinates)
            .frame(height: focusedField != nil ? 100 : 300)
            .animation(.none, value: focusedField)
            .onAppear(perform: setLocation)
            .onTapGesture(perform: dismissFocus)
        }
        .listRowBackground(Color.clear)
        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))

        Section {
          TextField("Name der Station", text: $name)
            .focused($focusedField, equals: .name)
          TextField("Aufgabe an der Station", text: $question)
            .focused($focusedField, equals: .question)
          Stepper(value: $triggerDistance, in: 5...50, step: 5) {
            HStack {
              Text("Min. Distanz:")
              Text("\(triggerDistance.formatted(.number))")
                .font(.headline)
            }
          }
        } footer: {
          Text("Distanz, die unterschritten werden muss, um diese Station zu aktivieren.")
        }
      }
      .toolbar(content: toolbarContent)
      .navigationBarTitleDisplayMode(.inline)
      .navigationTitle("Neue Station")
      .onChange(of: triggerDistance) { newValue in
        setSpanOfMap()
      }
      .onAppear {
        setSpanOfMap()
      }
    }
  }
}


extension AddNewStationView {
  private func saveButtonTapped() {
    let location = region.center
    stationsStore.newStation(with: name, triggerDistance: triggerDistance, question: question, and: location)
    reset()
  }

  private func dismissFocus() {
    self.focusedField = nil
  }

  private func reset() {
    self.name.removeAll()
    self.question.removeAll()
    self.focusedField = .name
  }

  private func setSpanOfMap() {
    region = MKCoordinateRegion(center: region.center, latitudinalMeters: mapSpanInMeters, longitudinalMeters: mapSpanInMeters)
  }

  private func setLocation() {
    if let lastStationCoordinate = stationsStore.allStations.last?.coordinate {
      region.center = .init(latitude: lastStationCoordinate.latitude, longitude: lastStationCoordinate.longitude)
    } else if let location = locationProvider.location?.coordinate {
      region.center = location
    }
    setSpanOfMap()
  }

  private func centerLocation() {
    if let location = locationProvider.location?.coordinate {
      region.center = location
      setSpanOfMap()
    }
  }

  // MARK: - Views
  func locationCoordinates() -> some View {
    Text("\(region.center.latitude), \(region.center.longitude)")
      .font(.footnote)
      .monospacedDigit()
      .padding(3)
      .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 5))
      .padding(.bottom, 10)
  }
  @ToolbarContentBuilder
  func toolbarContent() -> some ToolbarContent {
    ToolbarItem(placement: .navigationBarLeading) {
      Button("Abbrechen", action: dismiss.callAsFunction)
    }

    ToolbarItem(placement: .navigationBarTrailing) {
      Button("Speichern", action: saveButtonTapped)
        .disabled(saveButtonIsDisabled)
    }
  }

  private var centerMapButton: some View {
    Button(action: centerLocation) {
      Label("Karte zentrieren", systemImage: "mappin.circle")
        .labelStyle(.iconOnly)
        .font(.title2)
        .frame(width: 50, height: 50)
        .background(.green)
        .contentShape(Circle())
    }
    .padding()
  }
}
