//
//  Color+Extension.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 27.09.22.
//

import SwiftUI

extension Color {
  // --- Accent Colors
  static var primaryAccentColor: Color {
    Color("PrimaryAccentColor")
  }

  // --- Background Colors
  public static var primaryBackground: Color {
    Color("PrimaryBackground")
  }

  // --- UIColor Shortcuts
  static let label = Color(uiColor: .systemBackground)
}

extension UIColor {
  public static var primaryAccentColor: UIColor {
    UIColor(.primaryAccentColor)
  }
}
