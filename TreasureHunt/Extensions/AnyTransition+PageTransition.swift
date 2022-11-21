//
//  AnyTransition+PageTransition.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 21.11.22.
//

import SwiftUI

extension AnyTransition {
  static func pageTransition(_ isBack: Bool) -> AnyTransition {
    return .asymmetric(insertion: .move(edge: isBack ? .leading : .trailing),
                       removal: .move(edge: isBack ? .trailing : .leading))
  }
}
