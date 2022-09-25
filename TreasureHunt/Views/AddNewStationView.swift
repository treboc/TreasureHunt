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
  @State private var region: MKCoordinateRegion
  private var saveButtonIsDisabled: Bool {
    return name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
  }

  init(location: CLLocation) {
    let region = MKCoordinateRegion(center: location.coordinate,
                                latitudinalMeters: 1000,
                                longitudinalMeters: 1000)
    _region = State(initialValue: region)
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

struct InputView_Previews: PreviewProvider {
  static var previews: some View {
    AddNewStationView(location: CLLocation(latitude: 50, longitude: 6))
      .environmentObject(StationsStore())
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
}
