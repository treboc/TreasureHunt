//
//  HuntViewModel.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 25.09.22.
//

import SwiftUI

final class HuntViewModel: ObservableObject {
  @Published var mapIsHidden: Bool = true
  @Published var questionSheetIsShown: Bool = false
}
