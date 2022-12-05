//
//  LazyView.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 03.12.22.
//

import SwiftUI

struct LazyView<Content: View>: View {
  let build: () -> Content

  init(_ build: @autoclosure @escaping () -> Content) {
    self.build = build
  }

  var body: Content {
    build()
  }
}
