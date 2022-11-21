//
//  AddHuntView.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 03.10.22.
//

import SwiftUI
import MapKit
import RealmSwift

class AddHuntViewModel: ObservableObject {
  let locationProvider: LocationProvider

  var huntToEdit: Hunt?
  
  @Published var pageIdx: AddHuntView.PageSelection = .name
  @Published var isBack: Bool = false
  
  @Published var name: String = ""
  @Published var hasIntroduction: Bool = false
  @Published var introduction: String = ""
  
  @Published var hasOutline: Bool = false
  @Published var outline: String = ""
  @Published var outlineLocation: THLocation?
  
  @Published var stations: [THStation] = []

  init(locationProvider: LocationProvider) {
    self.locationProvider = locationProvider
  }

  init(locationProvider: LocationProvider, huntToEdit: Hunt) {
    self.locationProvider = locationProvider

    self.huntToEdit = huntToEdit
    _name = Published(initialValue: huntToEdit.name)
    if let intro = huntToEdit.introduction {
      _hasIntroduction = Published(initialValue: !intro.isEmpty)
      _introduction = Published(initialValue: intro)
    }
    if let outline = huntToEdit.outline {
      _hasOutline = Published(initialValue: !outline.isEmpty)
      _outline = Published(initialValue: outline)
    }

    for station in huntToEdit.stations {
      stations.append(station)
    }
  }

  var saveButtonIsDisabled: Bool {
    return name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || stations.isEmpty
  }

  func saveButtonTapped(onCompletion: @escaping (() -> Void)) {
    if let hunt = huntToEdit?.thaw() {
      try? HuntModelService.update(hunt, name: name, introduction: introduction, stations: stations, outline: outline)
    } else {
      HuntModelService.createHunt(name: name, introduction: introduction, stations: stations, outline: outline)
    }
    onCompletion()
  }

  func backButtonTapped() {
    isBack = true
    withAnimation {
      pageIdx = pageIdx.prevPage()
    }
  }

  func nextButtonTapped() {
    isBack = false
    withAnimation {
      pageIdx = pageIdx.nextPage()
    }
  }
}

struct AddHuntView: View {
  @StateObject var viewModel: AddHuntViewModel
  @Environment(\.dismiss) private var dismiss

  init(locationProvider: LocationProvider) {
    let viewModel = AddHuntViewModel(locationProvider: locationProvider)
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  init(locationProvider: LocationProvider, huntToEdit: Hunt) {
    let viewModel = AddHuntViewModel(locationProvider: locationProvider, huntToEdit: huntToEdit)
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  var body: some View {
    VStack {
      navButtonStack()

      switch viewModel.pageIdx {
      case .name:
        NamePage(pageIndex: viewModel.pageIdx,
                 name: $viewModel.name)
        .transition(.pageTransition(viewModel.isBack))
      case .intro:
        IntroductionPage(pageIndex: viewModel.pageIdx,
                         hasIntroduction: $viewModel.hasIntroduction,
                         introduction: $viewModel.introduction)
        .transition(.pageTransition(viewModel.isBack))
      case .stations:
        StationsPicker()
          .transition(.pageTransition(viewModel.isBack))
      case .outline:
        OutlinePage(pageIndex: viewModel.pageIdx,
                    hasOutline: $viewModel.hasOutline,
                    outline: $viewModel.outline,
                    outlineLocation: $viewModel.outlineLocation)
        .transition(.pageTransition(viewModel.isBack))
      }
    }
    .onChange(of: viewModel.pageIdx) { _ in
      HapticManager.shared.impact(style: .medium)
    }
    .toolbar(content: toolbarContent)
    .navigationTitle(viewModel.name.isEmpty ? L10n.AddHuntView.navTitle : viewModel.name)
    .roundedNavigationTitle()
    .toolbar(.hidden, for: .tabBar)
    .environmentObject(viewModel)
  }
}

struct AddHuntView_Previews: PreviewProvider {
  static var previews: some View {
    AddHuntView(locationProvider: LocationProvider())
  }
}

extension AddHuntView {
  //MARK: - Methods

}

extension AddHuntView {
  // MARK: - Views
  @ToolbarContentBuilder
  func toolbarContent() -> some ToolbarContent {
    ToolbarItem(placement: .navigationBarTrailing) {
      Button(L10n.BtnTitle.save) {
        viewModel.saveButtonTapped {
          dismiss()
        }
      }
      .disabled(viewModel.saveButtonIsDisabled)
    }
  }

  private func navButtonStack() -> some View {
    HStack {
      Button("Back", action: viewModel.backButtonTapped)
      .buttonStyle(.bordered)
      .opacity(viewModel.pageIdx == .name ? 0 : 1)

      Spacer()

      ZStack {
        Circle()
          .trim(from: 0, to: CGFloat(viewModel.pageIdx.rawValue + 1) * 0.25)
          .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
          .rotationEffect(.degrees(90))

        if !viewModel.saveButtonIsDisabled {
          Image(systemName: "checkmark")
            .font(.system(.headline, design: .rounded))
            .foregroundColor(.accentColor)
        } else {
          Text("\(viewModel.pageIdx.rawValue + 1)")
            .font(.system(.headline, design: .rounded))
            .foregroundColor(.accentColor)
        }
      }
      .frame(height: 30)
      .animation(.default, value: viewModel.pageIdx)

      Spacer()

      Button("Next", action: viewModel.nextButtonTapped)
      .buttonStyle(.bordered)
      .opacity(viewModel.pageIdx == .outline ? 0 : 1)
    }
    .padding(.horizontal)
  }
}
