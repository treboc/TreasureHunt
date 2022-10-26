//  Created by Dominik Hauser on 21.09.22.
//  
//

import RealmSwift
import SwiftUI
import MapKit

struct AddNewStationView: View {
  @EnvironmentObject private var locationProvider: LocationProvider
  @Environment(\.dismiss) private var dismiss

  private var stationToEdit: Station?

  @State private var region: MKCoordinateRegion = .init()
  @State private var name: String = ""
  @State private var question: String = ""
  @State private var triggerDistance: Double = 25
  @FocusState private var focusedField: Field?

  @State private var selectedPage: Int = 1
  private var isLastPageSelected: Bool {
    return selectedPage == 2
  }

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
      VStack {
        switch selectedPage {
        case 1:
          positionPage
            .transition(.move(edge: .leading))
        case 2:
          detailsPage
            .transition(.move(edge: .trailing))
        default:
          EmptyView()
        }

        PagePicker(selectedPage: $selectedPage)
      }
      .animation(.default, value: selectedPage)
      .toolbar(content: toolbarContent)
      .navigationBarTitleDisplayMode(.inline)
      .navigationTitle("Neue Station")
      .interactiveDismissDisabled()
      .onAppear {
        locationProvider.locationManager.requestWhenInUseAuthorization()
      }
      .task {
        setMapSpan()
      }
    }
  }
}

struct AddNewStationView_Previews: PreviewProvider {
  static let location = CLLocation(latitude: 50, longitude: 50)

  static var previews: some View {
    AddNewStationView(location: location)
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
    self.selectedPage = 1
  }

  private func setMapSpan() {
    region = MKCoordinateRegion(center: region.center,
                                latitudinalMeters: mapSpanInMeters,
                                longitudinalMeters: mapSpanInMeters)
  }

  private func setLocation() {
    centerLocation()
  }

  private func centerLocation() {
    if let location = locationProvider.currentLocation?.coordinate {
      region.center = location
    }
  }
}

extension AddNewStationView {
  // MARK: - Toolbar
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

  // MARK: - positionPage
  private var positionPage: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("1. Position")
        .font(.system(.title, design: .rounded, weight: .semibold))
      Text("Schiebe die Mitte der Karte an die Stelle, an der diese Station sein soll.")
        .font(.system(.body, design: .rounded))
        .foregroundColor(.secondary)

      mapView
        .overlay(alignment: .topTrailing) {
          centerMapButton
        }
        .onAppear {
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation {
              self.setMapSpan()
            }
          }
        }

      VStack {
        TriggerDistanceSlider(triggerDistance: $triggerDistance)
      }
    }
    .padding(.horizontal)
  }

  // MARK: - detailsPage
  private var detailsPage: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("2. Details")
        .font(.system(.title, design: .rounded, weight: .semibold))
      Text("Füge noch einen Namen und eine Aufgabe hinzu.")
        .lineLimit(2)
        .font(.system(.body, design: .rounded))
        .foregroundColor(.secondary)

      VStack(spacing: 16) {
        TextfieldWithTitle(title: "Name der Station",
                           placeholder: "z.B. An der alten Mühle",
                           text: $name,
                           focusField: _focusedField,
                           field: .name)

        TextfieldWithTitle(title: "Aufgabe an der Station",
                           placeholder: "z.B. Finde den größten Stein!",
                           text: $question,
                           focusField: _focusedField,
                           field: .question)
      }
      .padding(.vertical, 24)

      Spacer()
    }
    .padding(.horizontal)
    .onAppear {
      focusedField = .name
    }
  }
}

extension AddNewStationView {
  // MARK: - MapView
  private var mapView: some View {
    Map(coordinateRegion: $region, interactionModes: [.pan])
      .overlay {
        ZStack {
          Circle()
            .strokeBorder(.tint, lineWidth: 1)
            .background(Circle().foregroundColor(Color.black.opacity(0.2)))
          
          Image(systemName: "plus")
        }
        .frame(width: 60, height: 60)
        .accessibilityHidden(true)
        .allowsHitTesting(false)
      }
      .overlay(alignment: .bottom) { coordinatesOverlay }
      .frame(maxHeight: .infinity)
      .clipShape(RoundedRectangle(cornerRadius: 16))
      .animation(.none, value: selectedPage)
      .onChange(of: triggerDistance) { _ in
        setMapSpan()
      }
  }

  private var coordinatesOverlay: some View {
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
