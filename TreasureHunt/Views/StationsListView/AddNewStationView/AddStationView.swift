//  Created by Dominik Hauser on 21.09.22.
//  
//

import MapKit
import RealmSwift
import SwiftUI

struct AddStationView: View {
  @EnvironmentObject private var locationProvider: LocationProvider
  @Environment(\.dismiss) private var dismiss

  private var stationToEdit: Station?

  @State private var region: MKCoordinateRegion = .init()
  @State private var name: String = ""
  @State private var isFavorite: Bool = false
  @State private var triggerDistance: Double = 25
  @FocusState private var focusedField: Field?

  @State private var selectedPage: PageSelection = .position
  private var isLastPageSelected: Bool {
    return selectedPage == .details
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
      _isFavorite = State(initialValue: stationToEdit.isFavorite)
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
        case .position:
          positionPage
            .transition(.move(edge: .leading))
        case .details:
          detailsPage
            .transition(.move(edge: .trailing))
        }

        PagePicker(selectedPage: $selectedPage)
      }
      .animation(.default, value: selectedPage)
      .toolbar(content: toolbarContent)
      .navigationBarTitleDisplayMode(.inline)
      .navigationTitle(name.isEmpty ? L10n.AddStationView.navTitle : name)
      .interactiveDismissDisabled()
      .task {
        setMapSpan()
      }
    }
  }
}

extension AddStationView {
  // MARK: - Methods
  private func saveButtonTapped() {
    if let stationToEdit {
      try? StationModelService.update(stationToEdit, with: region.center, name: name, triggerDistance: triggerDistance, isFavorite: isFavorite)
      dismiss()
    } else {
      let station = Station(coordinate: region.center,
                            triggerDistance: triggerDistance,
                            name: name)
      try? StationModelService.add(station)
    }
    reset()
  }

  private func dismissFocus() {
    self.focusedField = nil
  }

  private func reset() {
    self.name.removeAll()
    self.selectedPage = .position
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

extension AddStationView {
  // MARK: - Toolbar
  @ToolbarContentBuilder
  func toolbarContent() -> some ToolbarContent {
    ToolbarItem(placement: .navigationBarLeading) {
      Button(L10n.BtnTitle.cancel, action: dismiss.callAsFunction)
    }

    ToolbarItem(placement: .navigationBarTrailing) {
      Button(L10n.BtnTitle.save, action: saveButtonTapped)
        .disabled(saveButtonIsDisabled)
    }
  }

  // MARK: - positionPage
  private var positionPage: some View {
    VStack(alignment: .leading) {
      Text(L10n.AddStationView.PositionPage.title)
        .font(.system(.title, design: .rounded, weight: .semibold))
      Text(L10n.AddStationView.PositionPage.description)
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
    VStack(alignment: .leading) {
      HStack(alignment: .center) {
        Text(L10n.AddStationView.DetailPage.title)
          .font(.system(.title, design: .rounded, weight: .semibold))

        Spacer()
  
        Image(systemName: isFavorite ? "star.fill" : "star")
          .font(.title2)
          .foregroundColor(.accentColor)
          .onTapGesture {
            withAnimation {
              isFavorite.toggle()
              HapticManager.shared.impact(style: .medium)
            }
          }
      }
      Text(L10n.AddStationView.DetailPage.description)
        .lineLimit(2)
        .font(.system(.body, design: .rounded))
        .foregroundColor(.secondary)

      VStack(spacing: 16) {
        VStack(alignment: .leading, spacing: 2) {
          Text(L10n.AddStationView.DetailPage.nameTextFieldTitle.uppercased())
            .foregroundColor(.secondary)
            .font(.caption)
            .padding(.leading)

          TextField(L10n.AddStationView.DetailPage.nameTextFieldPlaceholder, text: $name, axis: .vertical)
            .focused($focusedField, equals: .name)
            .padding(.vertical, 10)
            .padding(.horizontal)
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))
            .lineLimit(1...10)
            .scrollDismissesKeyboard(.interactively)
        }
      }
      .animation(.none, value: focusedField)
      .padding(.top, 16)
      Spacer()
    }
    .padding(.horizontal)
    .onAppear {
      focusedField = .name
    }
  }
}

extension AddStationView {
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

extension AddStationView {
  enum Field: Hashable {
    case name
  }
}
