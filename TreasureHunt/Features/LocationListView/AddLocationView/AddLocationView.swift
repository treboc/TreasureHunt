//  Created by Dominik Hauser on 21.09.22.
//  
//

import MapKit
import SwiftUI

struct AddLocationView: View {
  @EnvironmentObject private var locationProvider: LocationProvider
  @Environment(\.dismiss) private var dismiss

  private var locationToEdit: THLocation?

  @State private var region: MKCoordinateRegion = .init()
  @State private var title: String = ""
  @State private var isFavorite: Bool = false
  @State private var triggerDistance: Double = 25
  @State private var showLocationCreatedOverlay: Bool = false

  @FocusState private var textFieldIsFocused

  private var saveButtonIsDisabled: Bool {
    return title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
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
    _title = State(initialValue: location.unwrappedTitle)
    _isFavorite = State(initialValue: location.isFavourite)
    _triggerDistance = State(initialValue: location.triggerDistance)
    let region = MKCoordinateRegion(center: location.coordinate,
                                    latitudinalMeters: mapSpanInMeters,
                                    longitudinalMeters: mapSpanInMeters)
    _region = State(initialValue: region)
  }

  var body: some View {
    NavigationView {
      VStack(spacing: 16) {
        titleStack
        mapStack
      }
      .successPopover(isPresented: $showLocationCreatedOverlay, onDismiss: reset)
      .toolbar(content: toolbarContent)
      .navigationBarTitleDisplayMode(.inline)
      .navigationTitle(title.isEmpty ? L10n.AddLocationView.navTitle : title)
      .interactiveDismissDisabled()
    }
  }
}

extension AddLocationView {
  // MARK: - Methods
  private func saveButtonTapped() {
    if let locationToEdit {
      THLocationModelService.updateLocation(thLocation: locationToEdit,
                                       title: title,
                                       latitude: region.center.latitude,
                                       longitude: region.center.longitude,
                                       triggerDistance: triggerDistance)
    } else {
      THLocationModelService.addLocation(title: title,
                                    latitude: region.center.latitude,
                                    longitude: region.center.longitude,
                                    triggerDistance: triggerDistance)
    }
    self.showLocationCreatedOverlay = true
  }

  private func reset() {
    if locationToEdit == nil {
      self.title.removeAll()
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
  // MARK: - Views
  private var titleStack: some View {
    VStack(alignment: .leading) {
      HStack {
        THNumberedCircle(number: 1)
        Text(L10n.AddLocationView.title)
          .font(.headline)
      }
      TextField(L10n.AddLocationView.title, text: $title)
        .padding()
        .roundedBackground()
        .focused($textFieldIsFocused)
    }
    .padding(.horizontal)
  }

  private var mapStack: some View {
    VStack(alignment: .leading) {
      HStack {
        THNumberedCircle(number: 2)
        Text(L10n.AddLocationView.position)
          .font(.headline)
      }

      mapView
        .overlay(alignment: .topTrailing) {
          centerMapButton
        }
        .padding(.bottom, textFieldIsFocused ? 20 : 0)

      if !textFieldIsFocused {
        TriggerDistanceSlider(triggerDistance: $triggerDistance)
      }
    }
    .padding(.horizontal)
  }

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
      .roundedBackground()
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
