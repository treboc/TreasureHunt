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

  @State private var pageIdx: PageSelection = .name
  @State private var isBack: Bool = false

  @State private var name: String = ""
  @State private var hasIntroduction: Bool = false
  @State private var introduction: String = ""

  @State private var hasOutline: Bool = false
  @State private var outline: String = ""
  @State private var outlineLocation: THLocation?

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
    VStack {
      navButtonStack()

      switch pageIdx {
      case .name:
        NamePage(pageIndex: pageIdx,
                 name: $name)
        .transition(.pageTransition(isBack))
      case .intro:
        IntroductionPage(pageIndex: pageIdx,
                         hasIntroduction: $hasIntroduction,
                         introduction: $introduction)
        .transition(.pageTransition(isBack))
      case .stations:
        StationsPicker(stations: $stations)
          .transition(.pageTransition(isBack))
      case .outline:
        OutlinePage(pageIndex: pageIdx,
                    hasOutline: $hasOutline,
                    outline: $outline,
                    outlineLocation: $outlineLocation)
        .transition(.pageTransition(isBack))
      }
    }
    .onChange(of: pageIdx) { _ in
      HapticManager.shared.impact(style: .medium)
    }
    .toolbar(content: toolbarContent)
    .navigationTitle(name.isEmpty ? L10n.AddHuntView.navTitle : name)
    .roundedNavigationTitle()
    .toolbar(.hidden, for: .tabBar)
  }
}

struct AddHuntView_Previews: PreviewProvider {
  static var previews: some View {
    AddHuntView()
  }
}

extension AddHuntView {
  //MARK: - Methods
  func saveButtonTapped(onCompletion: @escaping (() -> Void)) {
    if let huntToEdit {
      try? HuntModelService.update(huntToEdit, name: name, introduction: introduction, stations: stations, outline: outline)
    } else {
      HuntModelService.createHunt(name: name, introduction: introduction, stations: stations, outline: outline)
    }
    dismiss()
  }
}

extension AddHuntView {
  // MARK: - Views


  @ToolbarContentBuilder
  func toolbarContent() -> some ToolbarContent {
    ToolbarItem(placement: .navigationBarTrailing) {
      Button(L10n.BtnTitle.save) {
        saveButtonTapped(onCompletion: dismiss.callAsFunction)
      }
      .disabled(saveButtonIsDisabled)
    }
  }

  private func navButtonStack() -> some View {
    HStack {
      Button("Back") {
        isBack = true
        withAnimation {
          pageIdx = pageIdx.prevPage()
        }
      }
      .buttonStyle(.bordered)
      .opacity(pageIdx == .name ? 0 : 1)

      Spacer()

      ZStack {
        Circle()
          .trim(from: 0, to: CGFloat(pageIdx.rawValue + 1) * 0.25)
          .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
          .rotationEffect(.degrees(90))

        if !saveButtonIsDisabled {
          Image(systemName: "checkmark")
            .font(.system(.headline, design: .rounded))
            .foregroundColor(.accentColor)
        } else {
          Text("\(pageIdx.rawValue + 1)")
            .font(.system(.headline, design: .rounded))
            .foregroundColor(.accentColor)
        }
      }
      .frame(height: 30)
      .animation(.default, value: pageIdx)

      Spacer()

      Button("Next") {
        isBack = false
        withAnimation {
          pageIdx = pageIdx.nextPage()
        }
      }
      .buttonStyle(.bordered)
      .opacity(pageIdx == .outline ? 0 : 1)
    }
    .padding(.horizontal)
  }
}
