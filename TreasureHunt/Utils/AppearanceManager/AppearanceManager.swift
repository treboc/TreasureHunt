//
//  AppearanceManager.swift
//  TreasureHunt
//
// https://gist.github.com/gavinjerman/a862e3dffa03468b8d1a5cf14e1c1f4f
// Based on this gist

import SwiftUI

class AppearanceManager: ObservableObject {
  @AppStorage("Appearance") var appearance: Appearance = .system {
    didSet {
      setAppearance()
    }
  }

  enum Appearance: String, CaseIterable, Equatable {
    case light
    case dark
    case system

    var title: String {
      switch self {
      case .dark:
        return "Dunkel"
      case .light:
        return "Hell"
      case .system:
        return "Standard"
      }
    }
  }

  func setAppearance() {
    switch appearance {
    case .light:
      window?.overrideUserInterfaceStyle = .light
    case .dark:
      window?.overrideUserInterfaceStyle = .dark
    case .system:
      window?.overrideUserInterfaceStyle = .unspecified
    }
  }

  private var window: UIWindow? {
    guard let scene = UIApplication.shared.connectedScenes.first,
          let windowSceneDelegate = scene.delegate as? UIWindowSceneDelegate,
          let window = windowSceneDelegate.window else {
      return nil
    }
    return window
  }
}
