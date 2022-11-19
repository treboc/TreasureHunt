//  Created by Dominik Hauser on 21.09.22.
//  
//

import MapKit
import RealmSwift
import SwiftUI

struct AddLocationView: View {
  @EnvironmentObject private var locationProvider: LocationProvider
  @Environment(\.dismiss) private var dismiss

  private var locationToEdit: THLocation?

  @State private var region: MKCoordinateRegion = .init()
  @State private var name: String = ""
  @State private var isFavorite: Bool = false
  @State private var triggerDistance: Double = 25
  @State private var showLocationCreatedOverlay: Bool = false

  private var saveButtonIsDisabled: Bool {
    return name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
  }

  private var mapSpanInMeters: CLLocationDistance {
    return triggerDistance * 10
  }

  init(location: CLLocation?) {
    let region = MKCoordinateRegion(center: location?.coordinate ?? .init(),
                                    latitudinalMeters: mapSpanInMeters,
                                    longitudinalMeters: mapSpanInMeters)
    _region = State(initialValue: region)
  }

  init(location: THLocation) {
    self.locationToEdit = location
    _name = State(initialValue: location.name)
    _isFavorite = State(initialValue: location.isFavorite)
    _triggerDistance = State(initialValue: location.triggerDistance)
    let region = MKCoordinateRegion(center: location.coordinate,
                                    latitudinalMeters: mapSpanInMeters,
                                    longitudinalMeters: mapSpanInMeters)
    _region = State(initialValue: region)
  }

  var body: some View {
    NavigationView {
      VStack(spacing: 16) {
        VStack(alignment: .leading) {
          Text("1 – Name")
            .font(.headline)
          TextField("Name", text: $name)
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: Constants.cornerRadius))
        }
        .padding(.horizontal)

        VStack(alignment: .leading) {
          Text("2 – Position")
            .font(.headline)

          mapView
            .overlay(alignment: .topTrailing) {
              centerMapButton
            }

          TriggerDistanceSlider(triggerDistance: $triggerDistance )
        }
        .padding(.horizontal)
      }
      .successPopover(isPresented: $showLocationCreatedOverlay, onDismiss: reset)
      .toolbar(content: toolbarContent)
      .navigationBarTitleDisplayMode(.inline)
      .navigationTitle(name.isEmpty ? L10n.AddStationView.navTitle : name)
      .interactiveDismissDisabled()
    }
  }
}

extension AddLocationView {
  // MARK: - Methods
  private func saveButtonTapped() {
    if let locationToEdit {
      try? StationModelService.update(locationToEdit, with: region.center, name: name, triggerDistance: triggerDistance, isFavorite: isFavorite)
    } else {
      let station = THLocation(coordinate: region.center,
                            triggerDistance: triggerDistance,
                            name: name)
      try? StationModelService.add(station)
    }
    self.showLocationCreatedOverlay = true
  }

  private func reset() {
    if locationToEdit == nil {
      self.name.removeAll()
    } else {
      dismiss()
    }
  }

  private func setMapSpan() {
    region = MKCoordinateRegion(center: region.center,
                                latitudinalMeters: mapSpanInMeters,
                                longitudinalMeters: mapSpanInMeters)
  }

  private func centerMapOnLocation() {
    if let location = locationProvider.currentLocation?.coordinate {
      region.center = location
    }
  }
}

extension AddLocationView {
  // MARK: - Toolbar
  @ToolbarContentBuilder
  func toolbarContent() -> some ToolbarContent {
    ToolbarItem(placement: .navigationBarLeading) {
      Button(L10n.BtnTitle.cancel, action: dismiss.callAsFunction)
    }

    ToolbarItem(placement: .navigationBarTrailing) {
      Button(L10n.BtnTitle.save, action: saveButtonTapped)
        .disabled(saveButtonIsDisabled)
        .fontWeight(.semibold)
    }
  }
}

extension AddLocationView {
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
      .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
      .onChange(of: triggerDistance) { _ in setMapSpan() }
  }

  private var coordinatesOverlay: some View {
    Text("\(region.center.latitude), \(region.center.longitude)")
      .font(.footnote)
      .monospacedDigit()
      .padding(3)
      .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: Constants.cornerRadius))
      .padding(.bottom, 10)
  }

  private var centerMapButton: some View {
    Button(action: centerMapOnLocation) {
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
