//
//  ThemeManager.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 26.12.22.
//

import SwiftUI

public class ThemeManager: ObservableObject {
  public enum Theme: String, CaseIterable {
    case orange
    case red
    case green
    case purple

    var tintColor: Color {
      switch self {
      case .orange: return .orange
      case .red: return .red
      case .green: return .green
      case .purple: return .purple
      }
    }
  }

  // MARK: - Private
  private static let themeKey = "theme"
  @AppStorage(ThemeManager.themeKey) private var theme: Theme = .orange
}

extension ThemeManager {
  // MARK: - Public
  public var tintColor: Color {
    return theme.tintColor
  }

  func setTheme(to theme: Theme) {
    self.theme = theme
  }

  func currentThemeIsEqual(to theme: Theme) -> Bool {
    self.theme == theme
  }
}

//extension Color: RawRepresentable, Codable {
//  public init?(rawValue: Int) {
//    let red =   Double((rawValue & 0xFF0000) >> 16) / 0xFF
//    let green = Double((rawValue & 0x00FF00) >> 8) / 0xFF
//    let blue =  Double(rawValue & 0x0000FF) / 0xFF
//    self = Color(red: red, green: green, blue: blue)
//  }
//
//  public var rawValue: Int {
//    guard let coreImageColor = coreImageColor else {
//      return 0
//    }
//    let red = Int(coreImageColor.red * 255 + 0.5)
//    let green = Int(coreImageColor.green * 255 + 0.5)
//    let blue = Int(coreImageColor.blue * 255 + 0.5)
//    return (red << 16) | (green << 8) | blue
//  }
//
//  private var coreImageColor: CIColor? {
//    return CIColor(color: .init(self))
//  }
//}
