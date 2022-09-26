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
  @State private var triggerDistance: Double = 5
  @FocusState private var focusedField: Field?

  private var saveButtonIsDisabled: Bool {
    return name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
  }

  var body: some View {
    NavigationView {
      Form {
        Section {
          Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: false)
            .overlay(Image(systemName: "circle"))
            .overlay(
              Text("\(region.center.latitude), \(region.center.longitude)")
                .font(.footnote)
                .monospacedDigit()
                .padding(3)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 5))
                .padding(.bottom, 10)
              , alignment: .bottom
            )
            .frame(height: focusedField != nil ? 100 : 300)
            .animation(.none, value: focusedField)
            .onAppear(perform: setLocation)
            .onTapGesture(perform: dismissFocus)
        }
        .listRowBackground(Color.clear)
        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))

        Section {
          TextField("Name", text: $name)
            .focused($focusedField, equals: .name)
          TextField("Frage", text: $question)
            .focused($focusedField, equals: .question)
          Stepper(value: $triggerDistance, in: 5...50, step: 5) {
            VStack(alignment: .leading) {
              Text("Auslöseentfernung:")
              Text("\(triggerDistance.formatted(.number))")
            }
          }
        }
      }
      .toolbar(content: toolbarContent)
      .navigationTitle("Neue Station")
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

  private func setLocation() {
    if let lastStationCoordinate = stationsStore.allStations.last?.coordinate {
      region.center = .init(latitude: lastStationCoordinate.latitude, longitude: lastStationCoordinate.longitude)
    } else if let location = locationProvider.location?.coordinate {
      region.center = location
    }
    region.span = .init(latitudeDelta: 0.005, longitudeDelta: 0.005)
  }

  @ToolbarContentBuilder
  func toolbarContent() -> some ToolbarContent {
    ToolbarItem(placement: .navigationBarLeading) {
      Button("Abbrechen", action: dismiss.callAsFunction)
    }

    ToolbarItem(placement: .navigationBarTrailing) {
      Button("Speichern", action: saveButtonTapped)
    }
  }
}
