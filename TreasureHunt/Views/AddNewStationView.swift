//  Created by Dominik Hauser on 21.09.22.
//  
//

import SwiftUI
import MapKit

struct AddNewStationView: View {
  @EnvironmentObject private var stationsStore: StationsStore
  @Environment(\.dismiss) private var dismiss

  @State private var name: String = ""
  @State private var question: String = ""
  @State private var triggerDistance: Double = 5
  @State private var region: MKCoordinateRegion = .init()

  private var saveButtonIsDisabled: Bool {
    return name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
  }

  var body: some View {
    NavigationView {
      Form {
        Section {
          Map(coordinateRegion: $region)
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
            .frame(height: 300)
            .onAppear(perform: setLocation)
        }
        .listRowBackground(Color.clear)
        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))

        Section {
          TextField("Name", text: $name)
          TextField("Frage", text: $question)
          Stepper(value: $triggerDistance, in: 5...50, step: 5) {
            VStack(alignment: .leading) {
              Text("Auslöseentfernung:")
              Text("\(triggerDistance.formatted(.number))")
            }
          }
        }

        Section {
          Button("Speichern", action: saveButtonTapped)
            .disabled(saveButtonIsDisabled)
        }
      }
      .toolbar {
        cancelButton
      }
      .navigationTitle("Neue Station")
    }
  }
}


extension AddNewStationView {
  private func saveButtonTapped() {
    let location = region.center
    stationsStore.newStation(with: name, triggerDistance: triggerDistance, question: question, and: location)
    dismiss.callAsFunction()
  }

  private var cancelButton: some View {
    Button("Abbrechen", action: dismiss.callAsFunction)
  }

  private func setLocation() {
    if let lastStationCoordinate = stationsStore.stations.last?.coordinate {
      self.region.center = .init(latitude: lastStationCoordinate.latitude, longitude: lastStationCoordinate.longitude)
      self.region.span = .init(latitudeDelta: 50, longitudeDelta: 50)
    }
  }
}
