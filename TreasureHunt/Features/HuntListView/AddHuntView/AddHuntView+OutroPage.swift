//
//  AddHuntView+OutroPage.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 19.11.22.
//

import SwiftUI

extension AddHuntView {
  struct OutroPage: View {
    @EnvironmentObject private var locationProvider: LocationProvider
    @EnvironmentObject private var viewModel: AddHuntViewModel
    @FocusState var isFocused
    @State private var outlineLocationSelectionSheetIsShown: Bool = false

    var body: some View {
      HStack(alignment: .firstTextBaseline) {
        THNumberedCircle(number: 4)

        VStack(alignment: .leading, spacing: Constants.rowSpacing) {
          VStack(alignment: .leading, spacing: 0) {
            Text(L10n.AddHuntView.OutroPage.hasHuntOutro)
              .font(.system(.title3, design: .rounded, weight: .semibold))
            Text(L10n.AddHuntView.OutroPage.hasHuntOutroDescription)
              .font(.system(.footnote, design: .rounded, weight: .regular))
              .foregroundColor(.secondary)
          }

          THToggle(isSelected: $viewModel.hunt.hasOutro)

          if viewModel.hunt.hasOutro {
            Group {
              TextField(L10n.AddHuntView.OutroPage.textFieldPlaceholder,
                        text: $viewModel.hunt.outro.boundString,
                        axis: .vertical)
              .lineLimit(3...10)
              .padding()
              .roundedBackground(shadowRadius: Constants.Shadows.firstLevel)
              .focused($isFocused)
              .onChange(of: viewModel.pageIndex, perform: dismissFocusOnChangeOf)

              selectableLocationView
                .roundedBackground(shadowRadius: Constants.Shadows.firstLevel)
            }
            .transition(.opacity.combined(with: .move(edge: .bottom)))
          }
        }
        .sheet(isPresented: $outlineLocationSelectionSheetIsShown) {
          LocationPicker(location: $viewModel.hunt.outroLocation)
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
      .animation(.easeInOut(duration: 0.3), value: viewModel.hunt.hasOutro)
      .padding()
      .onTapGesture { dismissFocus() }
    }

    private var selectableLocationView: some View {
      HStack {
        if let outroLocation = viewModel.hunt.outroLocation {
          Text(outroLocation.unwrappedTitle)
              .font(.system(.title3, design: .rounded, weight: .semibold))
              .fontWeight(.semibold)

          Spacer()

          VStack(alignment: .trailing) {
            Text(locationProvider.distanceTo(outroLocation.location))
            Text(L10n.HuntListDetailRowView.distanceFromHere)
              .font(.system(.caption, design: .rounded, weight: .light))
          }
        } else {
          VStack {
            Text(L10n.AddHuntView.OutroPage.SelectableLocationView.noLocationSelected)
              .font(.system(.body, design: .rounded, weight: .semibold))
            Text(L10n.AddHuntView.OutroPage.SelectableLocationView.noLocationSelectedSubheadline)
              .font(.system(.footnote, design: .rounded, weight: .semibold))
              .foregroundColor(.secondary)
          }
          .frame(maxWidth: .infinity, alignment: .center)
        }
      }
      .padding(.vertical, 4)
      .padding()
      .contentShape(Rectangle())
      .onTapGesture {
        outlineLocationSelectionSheetIsShown = true
      }
    }

    private func dismissFocusOnChangeOf(_ index: AddHuntView.PageSelection) {
      if index != .name {
        isFocused = false
      }
    }

    private func dismissFocus() {
      if isFocused {
        isFocused = false
      }
    }
  }


  //MARK: - LocationPicker
  struct LocationPicker: View {
    @EnvironmentObject private var locationProvider: LocationProvider
    @Environment(\.dismiss) private var dismiss

    @FetchRequest(sortDescriptors: [])
    private var locations: FetchedResults<THLocation>

    @Binding var location: THLocation?
    @State private var addNewLocationSheetIsShown: Bool = false

    var body: some View {
      NavigationView {
        VStack(spacing: Constants.rowSpacing) {
          ForEach(locations) { location in
            makeRowFor(location)
              .onTapGesture {
                selectStation(location)
              }
          }

          Button(action: showAddNewLocationSheet) {
            Text(L10n.AddHuntView.OutroPage.LocationPicker.addLocationBtnTitle)
              .frame(maxWidth: .infinity)
              .foregroundColor(Color(uiColor: .systemBackground))
          }
          .buttonStyle(.borderedProminent)
          .controlSize(.large)

          Spacer()
        }
        .padding([.horizontal])
        .sheet(isPresented: $addNewLocationSheetIsShown) {
          AddLocationView(location: locationProvider.currentLocation ?? .init())
        }
        .toolbar {
          Button(iconName: "xmark.circle.fill", action: dismiss.callAsFunction)
        }
        .navigationTitle(L10n.LocationsListView.navTitle)
      }
    }

    private func makeRowFor(_ location: THLocation) -> some View {
      HStack {
        Text(location.unwrappedTitle)
          .font(.system(.title3, design: .rounded, weight: .semibold))
          .fontWeight(.semibold)

        Spacer()

        VStack(alignment: .trailing) {
          Text(locationProvider.distanceTo(location.location))
          Text(L10n.HuntListDetailRowView.distanceFromHere)
            .font(.system(.caption, design: .rounded, weight: .light))
        }
      }
      .padding()
      .background(
        RoundedRectangle(cornerRadius: Constants.cornerRadius)
          .fill(.regularMaterial)
          .shadow(radius: Constants.Shadows.border)
      )
      .contentShape(Rectangle())
    }

    private func selectStation(_ location: THLocation) {
      let selectedLocation = PersistenceController.shared.copyForEditing(of: location, in: PersistenceController.shared.childContext)
      self.location = selectedLocation
      dismiss()
    }

    private func showAddNewLocationSheet() {
      addNewLocationSheetIsShown = true
    }
  }
}
