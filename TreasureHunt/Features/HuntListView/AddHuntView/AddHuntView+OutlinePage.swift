//
//  AddHuntView+OutlinePage.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 19.11.22.
//

import RealmSwift
import SwiftUI

extension AddHuntView {
  struct OutlinePage: View {
    @EnvironmentObject private var locationProvider: LocationProvider
    let pageIndex: PageSelection
    @Binding var hasOutline: Bool
    @Binding var outline: String
    @Binding var outlineLocation: THLocation?
    @FocusState var isFocused

    @State private var outlineLocationSelectionSheetIsShown: Bool = false

    var body: some View {
      HStack(alignment: .firstTextBaseline) {
        THNumberedCircle(number: 4)

        VStack(alignment: .leading, spacing: Constants.rowSpacing) {
          VStack(alignment: .leading, spacing: 0) {
            Text("Does your hunt has an outline?")
              .font(.system(.title3, design: .rounded, weight: .semibold))
            Text("Let your hunt end with some text, if you want. This will be displayed when reaching the last station.")
              .font(.system(.footnote, design: .rounded, weight: .regular))
              .foregroundColor(.secondary)
          }

          THToggle(isSelected: $hasOutline)

          if hasOutline {
            TextField("This text will show up.", text: $outline, axis: .vertical)
              .lineLimit(3...10)
              .padding()
              .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: Constants.cornerRadius))
              .transition(.opacity.combined(with: .move(edge: .bottom)))
              .focused($isFocused)
              .onChange(of: pageIndex) { index in
                if index != .name {
                  isFocused = false
                }
              }

            selectableLocationView
              .transition(.opacity.combined(with: .move(edge: .bottom)))
          }
        }
        .sheet(isPresented: $outlineLocationSelectionSheetIsShown) {
          LocationPicker(location: $outlineLocation)
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
      .animation(.easeInOut(duration: 0.3), value: hasOutline)
      .padding()
      .onTapGesture {
        if isFocused {
          isFocused = false
        }
      }
    }

    private var selectableLocationView: some View {
      HStack {
        if let outlineLocation {
          Text(outlineLocation.name)
              .font(.system(.title3, design: .rounded, weight: .semibold))
              .fontWeight(.semibold)

          Spacer()

          VStack(alignment: .trailing) {
            Text(locationProvider.distanceToAsString(outlineLocation.location))
            Text(L10n.HuntListDetailRowView.distanceFromHere)
              .font(.system(.caption, design: .rounded, weight: .light))
          }
        } else {
          VStack {
            Text("No Location Selected")
              .font(.system(.body, design: .rounded, weight: .semibold))
            Text("Tap to select one.")
              .font(.system(.footnote, design: .rounded, weight: .semibold))
              .foregroundColor(.secondary)
          }
          .frame(maxWidth: .infinity, alignment: .center)
        }
      }
      .padding(.vertical, 4)
      .padding()
      .background(
        RoundedRectangle(cornerRadius: Constants.cornerRadius)
          .fill(.regularMaterial)
      )
      .contentShape(Rectangle())
      .onTapGesture {
        outlineLocationSelectionSheetIsShown = true
      }
    }
  }

  //MARK: - LocationPicker
  struct LocationPicker: View {
    @EnvironmentObject private var locationProvider: LocationProvider
    @Environment(\.dismiss) private var dismiss
    @ObservedResults(THLocation.self) private var locations
    @Binding var location: THLocation?
    @State private var addNewLocationSheetIsShown: Bool = false

    var body: some View {
      NavigationView {
        VStack(spacing: Constants.rowSpacing) {
          ForEach(locations) { location in
            makeRowFor(location)
              .onTapGesture {
                self.location = location
                dismiss()
              }
          }

          Button {
            addNewLocationSheetIsShown = true
          } label: {
            Text("Add Location")
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
        .navigationTitle("Location")
      }
    }

    private func makeRowFor(_ location: THLocation) -> some View {
      HStack {
        Text(location.name)
          .font(.system(.title3, design: .rounded, weight: .semibold))
          .fontWeight(.semibold)

        Spacer()

        VStack(alignment: .trailing) {
          Text(locationProvider.distanceToAsString(location.location))
          Text(L10n.HuntListDetailRowView.distanceFromHere)
            .font(.system(.caption, design: .rounded, weight: .light))
        }
      }
      .padding()
      .background(
        RoundedRectangle(cornerRadius: Constants.cornerRadius)
          .fill(.regularMaterial)
      )
      .contentShape(Rectangle())
    }
  }
}
