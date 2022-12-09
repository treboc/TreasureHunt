//
//  AddHuntViewModel.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 03.12.22.
//

import Combine
import CoreData
import SwiftUI

class AddHuntViewModel: ObservableObject {
  let locationProvider: LocationProvider
  @Environment(\.managedObjectContext) private var moc

  @Published var hunt: THHunt

  var navTitle: String {
    return hunt.unwrappedTitle.isEmpty ? L10n.AddHuntView.navTitle : hunt.unwrappedTitle
  }

  @Published var pageIdx: AddHuntView.PageSelection = .name
  @Published var isBack: Bool = false

  init(locationProvider: LocationProvider, huntToEdit: THHunt?) {
    let childContext = PersistenceController.shared.childContext

    if let huntToEdit, let childObject = try? childContext.existingObject(with: huntToEdit.objectID) as? THHunt {
      self.hunt = childObject
    } else {
      self.hunt = THHunt(context: childContext)
    }

    self.locationProvider = locationProvider
  }

  var saveButtonIsDisabled: Bool {
    return !huntFormIsValid()
  }

  func saveButtonTapped(onCompletion: @escaping (() -> Void)) {
    THHuntModelService.updateHunt(hunt: hunt)
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

  func saveNewStation(_ station: THStation) {
    hunt.addToStations(station)
    objectWillChange.send()
  }
}

extension AddHuntViewModel {
  private func huntFormIsValid() -> Bool {
    return !hunt.unwrappedTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !hunt.stationsArray.isEmpty
  }
}
