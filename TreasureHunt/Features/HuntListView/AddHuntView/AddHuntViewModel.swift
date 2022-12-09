//
//  AddHuntViewModel.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 03.12.22.
//

import Combine
import SwiftUI

class AddHuntViewModel: ObservableObject {
  let locationProvider: LocationProvider
  @Environment(\.managedObjectContext) private var moc
  @Published var hunt: THHunt? = nil

  var navTitle: String {
    return title.isEmpty ? L10n.AddHuntView.navTitle : title
  }

  @Published var pageIdx: AddHuntView.PageSelection = .name
  @Published var isBack: Bool = false

  @Published var title: String = ""

  @Published var hasIntroduction: Bool = false
  @Published var introduction: String = ""

  @Published var stations: [THStation] = []

  @Published var hasOutline: Bool = false
  @Published var outline: String = ""
  @Published var outlineLocation: THLocation?

  init(locationProvider: LocationProvider) {
    self.locationProvider = locationProvider
  }

  init(locationProvider: LocationProvider, huntToEdit: THHunt) {
    self.locationProvider = locationProvider
    setupEditHunt(huntToEdit)
  }

  var saveButtonIsDisabled: Bool {
    return !huntFormIsValid()
  }

  func saveButtonTapped(onCompletion: @escaping (() -> Void)) {
    if let hunt {
      HuntModelService.updateHunt(hunt: hunt,
                                  title: title,
                                  hasIntroduction: hasIntroduction,
                                  introduction: introduction,
                                  hasOutline: hasOutline,
                                  outline: outline,
                                  outlineLocation: outlineLocation,
                                  stations: stations)
    } else {
      HuntModelService.createHunt(title: title,
                                  hasIntroduction: hasIntroduction,
                                  introduction: introduction,
                                  hasOutline: hasOutline,
                                  outline: outline,
                                  outlineLocation: outlineLocation,
                                  stations: stations)
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

extension AddHuntViewModel {
  private func huntFormIsValid() -> Bool {
    return !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !stations.isEmpty
  }

  private func setupEditHunt(_ hunt: THHunt) {
    self.hunt = hunt
    self.title = hunt.unwrappedTitle
    self.hasIntroduction = hunt.hasIntroduction

    if hunt.hasIntroduction {
      self.introduction = hunt.unwrappedIntroduction
    }

    self.hasOutline = hunt.hasOutline
    if hunt.hasOutline {
      self.outline = hunt.unwrappedOutline
      self.outlineLocation = hunt.outlineLocation
    }

    self.stations = hunt.stationsArray
  }
}
