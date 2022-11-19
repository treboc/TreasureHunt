//
//  Button+Extension.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 12.05.22.
//

import SwiftUI

/// https://www.swiftbysundell.com/tips/swiftui-extensions-using-generics/
extension Button where Label == Image {
  init(iconName: String, action: @escaping () -> Void) {
    self.init(action: action) {
      Image(systemName: iconName)
    }
  }
}
