//  Created by Dominik Hauser on 21.09.22.
//  
//

import SwiftUI
import MapKit

struct AddNewStationView: View {
  enum Field: Hashable {
    case name, question
  }

  var stationToEdit: Station?

  @EnvironmentObject private var stationsStore: StationsStore
  private var locationProvider = LocationProvider()

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

  init(stationToEdit: Station? = nil) {
    self.stationToEdit = stationToEdit
  }

  var body: some View {
    NavigationView {
      Form {
        Section {
          ZStack(alignment: .topTrailing) {
            mapView
            centerMapButton
          }
        }
        .listRowBackground(Color.clear)
        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))

        Section {
          TextField("Name der Station", text: $name)
            .focused($focusedField, equals: .name)

          TextField("Aufgabe an der Station", text: $question)
            .focused($focusedField, equals: .question)

          distanceSlider
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
      .onAppear(perform: prepareEdit)
      .interactiveDismissDisabled()
    }
  }
}


extension AddNewStationView {
  // MARK: - Methods
  private func saveButtonTapped() {
    if let stationToEdit {
      stationsStore.updateStation(stationToEdit,
                                  with: name,
                                  triggerDistance: triggerDistance,
                                  question: question,
                                  and: region.center)
      dismiss()
    } else {
      stationsStore.newStation(with: name,
                               triggerDistance: triggerDistance,
                               question: question,
                               and: region.center)
    }
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

  private func prepareEdit() {
    guard let stationToEdit else {
      setLocation()
      return
    }
    name = stationToEdit.name
    question = stationToEdit.question
    triggerDistance = stationToEdit.triggerDistance
    region.center = stationToEdit.location.coordinate
    setSpanOfMap()
  }

  private func setSpanOfMap() {
    region = MKCoordinateRegion(center: region.center,
                                latitudinalMeters: mapSpanInMeters,
                                longitudinalMeters: mapSpanInMeters)
  }

  private func setLocation() {
    if let lastStationCoordinate = stationsStore.allStations.last?.coordinate {
      region.center = .init(latitude: lastStationCoordinate.latitude, longitude: lastStationCoordinate.longitude)
    } else {
      centerLocation()
    }
    setSpanOfMap()
  }

  private func centerLocation() {
    if let location = locationProvider.currentLocation?.coordinate {
      region.center = location
      setSpanOfMap()
    }
  }
}

extension AddNewStationView {
  // MARK: - Views
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

  private var mapView: some View {
    Map(coordinateRegion: $region, interactionModes: [.pan])
      .overlay(
        Image(systemName: "plus")
          .allowsHitTesting(false)
      )
      .overlay(
        Circle()
          .strokeBorder(Color.red, lineWidth: 1)
          .background(Circle().foregroundColor(Color.black.opacity(0.1)))
          .frame(width: 60, height: 60)
          .allowsHitTesting(false)
      )
      .overlay(alignment: .bottom, content: locationCoordinates)
      .animation(.none, value: focusedField)
      .onTapGesture(perform: dismissFocus)
      .frame(minHeight: 100, idealHeight: 300, maxHeight: 300)
  }

  func locationCoordinates() -> some View {
    Text("\(region.center.latitude), \(region.center.longitude)")
      .font(.footnote)
      .monospacedDigit()
      .padding(3)
      .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 5))
      .padding(.bottom, 10)
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

  private var distanceSlider: some View {
    VStack {
      Slider(value: $triggerDistance, in: 5...300, step: 5)
      HStack {
        Text("Min. Distanz:")
        Spacer()
        Text("\(triggerDistance.formatted(.number))")
          .font(.headline)
      }
    }
    .padding(.vertical)
  }
}
