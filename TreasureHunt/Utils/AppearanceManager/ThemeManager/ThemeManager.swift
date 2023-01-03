//
//  ThemeManager.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 26.12.22.
//

import SwiftUI

extension Color {
  static let labelColor: Color = ThemeManager.shared.theme.labelColor
}

public class ThemeManager: ObservableObject {
  public enum Theme: String, CaseIterable, Identifiable {
    case orange
    case red
    case green
    case purple

    public var id: String { self.rawValue }

    var tintColor: Color {
      switch self {
      case .orange: return .orange
      case .red: return .red
      case .green: return .green
      case .purple: return .purple
      }
    }

    var labelColor: Color {
      return tintColor.isDarkColor ? .white : .black
    }
  }

  // MARK: - Private
  private static let themeKey = "theme"
  @AppStorage(ThemeManager.themeKey) var theme: Theme = .orange

  static let shared = ThemeManager()

  private init() {}
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

struct ThemeKey: EnvironmentKey {
  static var defaultValue: ThemeManager.Theme = ThemeManager.shared.theme
}

extension EnvironmentValues {
  var theme: ThemeManager.Theme {
    get { self[ThemeKey.self] }
    set { self[ThemeKey.self] = newValue }
  }
}

struct ThemeModifier: ViewModifier {
  @ObservedObject private var themeManger = ThemeManager.shared

  func body(content: Content) -> some View {
    content
      .environment(\.theme, themeManger.theme)
  }
}

extension View {
  func themed() -> some View {
    modifier(ThemeModifier())
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
