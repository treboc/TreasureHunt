//  Created by Dominik Hauser on 21.09.22.
//  
//

import RealmSwift
import SwiftUI
import MapKit

struct AddNewStationView: View {
  private var stationToEdit: Station?
  @ObservedResults(Station.self) private var realmStations
  let locationProvider = LocationProvider()

  @Environment(\.dismiss) private var dismiss

  @State private var region: MKCoordinateRegion = .init()
  @State private var name: String = ""
  @State private var question: String = ""
  @State private var triggerDistance: Double = 25
  @FocusState private var focusedField: Field?

  private var saveButtonIsDisabled: Bool {
    return name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
  }

  private var mapSpanInMeters: CLLocationDistance {
    return triggerDistance * 10
  }

  init(stationToEdit: Station? = nil, location: CLLocation? = nil) {
    if let stationToEdit {
      self.stationToEdit = stationToEdit
      _name = State(initialValue: stationToEdit.name)
      _question = State(initialValue: stationToEdit.question)
      _triggerDistance = State(initialValue: stationToEdit.triggerDistance)

      let region = MKCoordinateRegion(center: stationToEdit.coordinate,
                                      latitudinalMeters: mapSpanInMeters,
                                      longitudinalMeters: mapSpanInMeters)
      _region = State(initialValue: region)
    } else {
      if let location {
        let region = MKCoordinateRegion(center: location.coordinate,
                                        latitudinalMeters: mapSpanInMeters,
                                        longitudinalMeters: mapSpanInMeters)
        _region = State(initialValue: region)
        setMapSpan()
      }
    }
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

          TriggerDistanceSlider(triggerDistance: $triggerDistance)
        } footer: {
          Text("Distanz, die unterschritten werden muss, um diese Station zu aktivieren.")
        }
      }
      .scrollDismissesKeyboard(.interactively)
      .toolbar(content: toolbarContent)
      .navigationBarTitleDisplayMode(.inline)
      .navigationTitle("Neue Station")
      .onChange(of: triggerDistance) { _ in
        setMapSpan()
      }
      .interactiveDismissDisabled()
    }
  }
}


extension AddNewStationView {
  // MARK: - Methods
  private func saveButtonTapped() {
    if let stationToEdit {
      try? StationModelService.update(stationToEdit, with: region.center, name: name, triggerDistance: triggerDistance, question: question)
      dismiss()
    } else {
      let station = Station(coordinate: region.center,
                            triggerDistance: triggerDistance,
                            name: name,
                            question: question)
      try? StationModelService.add(station)
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

  private func setMapSpan() {
    region = MKCoordinateRegion(center: region.center,
                                latitudinalMeters: mapSpanInMeters,
                                longitudinalMeters: mapSpanInMeters)
  }

  private func setLocation() {
    if let lastStationCoordinate = realmStations.last?.coordinate {
      region.center = .init(latitude: lastStationCoordinate.latitude, longitude: lastStationCoordinate.longitude)
    } else {
      centerLocation()
    }
  }

  private func centerLocation() {
    if let location = locationProvider.currentLocation?.coordinate {
      region.center = location
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
          .strokeBorder(.tint, lineWidth: 1)
          .background(Circle().foregroundColor(Color.black.opacity(0.2)))
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
}

extension AddNewStationView {
  enum Field: Hashable {
    case name, question
  }
}

extension AddNewStationView {
  struct TriggerDistanceSlider: View {
    @Binding var triggerDistance: Double

    private let distanceFormatter: LengthFormatter = {
      let formatter = LengthFormatter()
      formatter.unitStyle = .short
      return formatter
    }()

    private var distanceString: String {
      distanceFormatter.string(fromMeters: triggerDistance)
    }

    var body: some View {
      VStack {
        Slider(value: $triggerDistance, in: 5...300, step: 5)
        HStack {
          Text("Min. Distanz:")
          Spacer()
          Text(distanceString)
            .font(.headline)
        }
      }
      .padding(.vertical)
    }
  }
}
