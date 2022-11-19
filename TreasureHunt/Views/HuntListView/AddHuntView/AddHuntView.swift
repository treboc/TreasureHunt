//
//  AddHuntView.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 03.10.22.
//

import SwiftUI
import MapKit
import RealmSwift

struct AddHuntView: View {
  @EnvironmentObject private var locationProvider: LocationProvider
  @Environment(\.dismiss) private var dismiss

  private var huntToEdit: Hunt?

  @State private var name: String = ""
  @State private var hasIntroduction: Bool = false
  @State private var introduction: String = ""

  @State private var hasOutline: Bool = false
  @State private var outline: String = ""

  @State private var stations: [THStation] = []
  @State private var region: MKCoordinateRegion = .init()
  @State private var mapIsShown: Bool = false

  private var saveButtonIsDisabled: Bool {
    return name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || stations.isEmpty
  }

  init() {}

  init(huntToEdit: Hunt) {
    self.huntToEdit = huntToEdit
    _name = State(initialValue: huntToEdit.name)
    let stations: [THStation] = Array(huntToEdit.stations)
    _stations = State(initialValue: stations)
  }

  var body: some View {
    NavigationView {
      Form {
        // Name
        Section(L10n.AddHuntView.name) {
          TextField(L10n.AddHuntView.namePlaceholder, text: $name)
        }

        // Introduction
        Section("Introduction") {
          Toggle("Introdruction", isOn: $hasIntroduction)
          if hasIntroduction {
            TextField("Something to introduce the hunt..", text: $introduction, axis: .vertical)
              .lineLimit(10, reservesSpace: true)
          }
        }

        // Stations
        Section {
          if stations.isEmpty {
            Text("No stations here yet..")
              .foregroundColor(.secondary)
              .italic()
          } else {
            ForEach(stations) { station in
              Text("\(station.name)")
            }
          }
          Button("+ Add Station") {
            
          }
        }


        // Outline
        Section("Outline") {
          Toggle("Outline", isOn: $hasOutline)
          if hasOutline {
            TextField("Something to outline the hunt..", text: $outline, axis: .vertical)
              .lineLimit(10, reservesSpace: true)
          }
        }
      }
      .toolbar(content: toolbarContent)
      .navigationTitle(name.isEmpty ? L10n.AddHuntView.navTitle : name)
      .roundedNavigationTitle()
    }
  }
}

struct AddHuntView_Previews: PreviewProvider {
  static var previews: some View {
    Text("")
      .popover(isPresented: .constant(true)) {
        AddHuntView()
          .environmentObject(LocationProvider())
      }
  }
}

extension AddHuntView {
  func saveButtonTapped(onCompletion: @escaping (() -> Void)) {
    if let huntToEdit {
      try? HuntModelService.update(huntToEdit, with: name, and: stations)
    } else {
      let hunt = Hunt(name: name)
      HuntModelService.add(hunt, with: stations)
    }
    dismiss()
  }
}

extension AddHuntView {
  // MARK: - Views
  @ToolbarContentBuilder
  func toolbarContent() -> some ToolbarContent {
    ToolbarItem(placement: .navigationBarLeading) {
      Button(L10n.BtnTitle.cancel, action: dismiss.callAsFunction)
    }

    ToolbarItem(placement: .navigationBarTrailing) {
      Button(L10n.BtnTitle.save) {
        saveButtonTapped(onCompletion: dismiss.callAsFunction)
      }
      .disabled(saveButtonIsDisabled)
    }
  }

//  @ViewBuilder
//  private var stationOverview: some View {
//    if mapIsShown {
//      Section {
//        ZStack(alignment: .topTrailing) {
//          Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: chosenStations, annotationContent: { station in
//            if let coordinates = station.location?.location.coordinate {
//              MapAnnotation(coordinate: coordinates) {
//                let index = chosenStations.firstIndex(of: station) ?? 0
//                AddHuntStationAnnotationView(position: index + 1)
//              }
//            } else {
//              EmptyView()
//            }
//          })
//          .overlay(alignment: .topTrailing) { centerMapButton }
//        }
//        .frame(height: 300)
//      } header: {
//        HStack {
//          Text(L10n.AddHuntView.overview)
//          Spacer()
//          Image(systemName: "chevron.down")
//            .rotationEffect(Angle(degrees: mapIsShown ? 0 : -90))
//        }
//        .padding()
//        .contentShape(Rectangle())
//        .onTapGesture {
//          withAnimation {
//            mapIsShown.toggle()
//          }
//        }
//      }
//      .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
//    } else {
//      HStack {
//        Text(L10n.AddHuntView.stationsOverview)
//        Spacer()
//        Image(systemName: "chevron.down")
//          .rotationEffect(Angle(degrees: mapIsShown ? 0 : -90))
//      }
//      .contentShape(Rectangle())
//      .onTapGesture {
//        withAnimation {
//          mapIsShown.toggle()
//        }
//      }
//    }
//  }
//
//  private var centerMapButton: some View {
//    Button(action: centerLocation) {
//      ZStack {
//        Circle()
//          .fill(.background)
//        Image(systemName: "mappin.and.ellipse")
//          .foregroundColor(.primary)
//      }
//      .frame(width: 32, height: 32)
//    }
//    .padding()
//    .contentShape(Circle())
//  }
}
